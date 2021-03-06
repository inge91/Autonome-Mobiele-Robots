from threading import Thread
import time

class Errors():
    def __init__(self):
        self.current     = 0
        self.previous    = 0
        self.preprevious = 0

    def update(self, new):
        self.preprevious = self.previous
        self.previous    = self.current
        self.current     = new

class PID_straight(Thread):
    """ A PID controller that corrects the robot's trajectory while moving
    straight ahead """
    def __init__(self, leftWheel, rightWheel, samplingTime):
        Thread.__init__(self)
        self.daemon = True

        self.leftWheel  = leftWheel
        self.rightWheel = rightWheel
        self.samplingTime = samplingTime

        self.running = True

    def run(self):
        errors = Errors()
        leftPower  = 80
        rightPower = 80

        while self.running:
            # reset the wheels
            self.leftWheel.reset_position(False)
            self.rightWheel.reset_position(False)

            # sleep for the specified amount of time and measure the
            # distance traveled by both wheels
            time.sleep(self.samplingTime)
            left_count = self.leftWheel.get_tacho().rotation_count
            right_count = self.rightWheel.get_tacho().rotation_count

            # the error represents how much more the left wheel has turned
            # compared to the right wheel, thus compensation needs to be done on
            # the right wheel
            error = left_count - right_count


            errors.update(error)

            proportional = errors.current
            derivative   = (errors.previous - errors.current) / self.samplingTime
            integral     = (errors.preprevious + errors.previous +
                    errors.current) / (3 * self.samplingTime)

            rightCompensation = (0.01 * proportional + 0.01 * derivative +
                    0.01 * integral)

            if abs(error) > 3:
                rightPower += rightCompensation
                rightPower = min(rightPower, 127)
                rightPower = max(rightPower, -128)

            print leftPower, rightPower
            print proportional

            self.rightWheel.weak_turn(rightPower, 1000)
            self.leftWheel.weak_turn(leftPower, 1000)

if __name__ == '__main__':
    import nxt
    import movement as m

    brick = nxt.find_one_brick()
    leftWheel = nxt.Motor(brick, m.LEFT_WHEEL)
    rightWheel = nxt.Motor(brick, m.RIGHT_WHEEL)

    pid = PID_straight(leftWheel, rightWheel, 0.05)
    pid.start()

    for _ in xrange(5):
        time.sleep(1)

    pid.running = False
    leftWheel.idle()
    rightWheel.idle()
