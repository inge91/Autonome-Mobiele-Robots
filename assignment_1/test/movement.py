import nxt
import numpy
from pylab import *
from threading import Thread
import time
import odometrie_tester as od

LEFT_WHEEL    = nxt.PORT_C
RIGHT_WHEEL   = nxt.PORT_B
WHEEL_DISTACE = 60 # distance between the wheels in millimeters
WHEEL_RADIUS  = 28 # wheel radius in millimeters

class WheelMover(Thread):
    def __init__(self, motor, power, distance, brake):
        Thread.__init__(self)
        self.power = power
        self.motor = motor
        self.distance = distance
        self.brake = brake

    def run(self):
        self.motor.turn(self.power, self.distance, brake=self.brake)

class Forward():
    def __init__(self, brick, power, distance):
        self.brick    = brick
        self.power    = power
        self.distance = distance

    def go(self):
        left_wheel  = nxt.Motor(self.brick, nxt.PORT_C)
        right_wheel = nxt.Motor(self.brick, nxt.PORT_B)

        leftMover  = WheelMover(left_wheel, self.power, self.distance, True)
        rightMover = WheelMover(right_wheel, self.power, self.distance, True)

        leftMover.start()
        rightMover.start()

        leftMover.join()
        rightMover.join()

class Rotate():
    def __init__(self, brick, wheel_port, power, distance):
        self.brick      = brick
        self.wheel_port = wheel_port
        self.power      = power
        self.distance   = distance

    def go(self):
        wheel  = nxt.Motor(self.brick, self.wheel_port)

        # because we're only using one wheel, that single wheel must rotate
        # twice the desired rotation
        turner = WheelMover(wheel, self.power, self.distance * 2, False)

        turner.start()

        turner.join()


def path(pth, brick):
    """ Follows a path, given by a list of objects.
    Returns the offset [x, y, theta] in world coordinates relative to when the
    path was initiated."""

    def rotation_matrix(theta):
        return matrix(
                [[cos(theta)  , sin(theta) , 0] ,
                 [-sin(theta) , cos(theta) , 0]  ,
                 [0           , 0          , 1]])

    position = matrix([0.0, 0.0, 0.0]).T

    # Create the odometrie tester object
    tester = od.Odometry()

    # Create right wheel and left wheel objects
    left_wheel  = nxt.Motor(brick, nxt.PORT_C)
    right_wheel = nxt.Motor(brick, nxt.PORT_B)

    for mover in pth:
        R = rotation_matrix(position[2, 0]) # from global to reference
        Rinv = np.linalg.inv(R)             # from reference to global

        # first calculate where we should end up after this step
        if isinstance(mover, Forward):
            # displacement in the local coordinate frame
            displacement = matrix([mover.distance * WHEEL_RADIUS, 0, 0]).T

            # update the position in the global frame
            position += Rinv * displacement

        elif isinstance(mover, Rotate):
            rot_radian = mover.distance * (pi / 180.0)
            x_comp = (0.5 * WHEEL_DISTACE) - (0.5 * WHEEL_DISTACE *
                    sin(rot_radian))
            y_comp = (0.5 * WHEEL_DISTACE) - (0.5 * WHEEL_DISTACE *
                    cos(rot_radian))

            # update the position in the global frame
            displacement = matrix([x_comp, y_comp, rot_radian]).T
            position += Rinv * displacement

        # reset the wheel position
        left_wheel.reset_position(False)
        right_wheel.reset_position(False)

        mover.go()
        time.sleep(2)

        # store the rotations
        left_rotations = left_wheel.get_tacho().rotation_count
        right_rotations = right_wheel.get_tacho().rotation_count
        print "left rotations in movement.py : ",
        print left_rotations

        if(isinstance(mover, Forward)):
            # send rotation count to function that calculates position
            print "distance"
            print mover.distance
            tester.add_rotations(left_rotations, right_rotations, mover.distance,
                    mover.distance)
        elif(isinstance(mover, Rotate)):
            # if rotates around left give the rotation degree only to
            # right_rotations
            if(mover.wheel_port == LEFT_WHEEL):
                tester.add_rotations(left_rotations, right_rotations,
                        mover.distance * 2, 0)
            else:
                tester.add_rotations(left_rotations, right_rotations,
                        0, mover.distance * 2)
        
    print tester.get_difference()

    return position

def main():
    # find a brick
    brick = nxt.find_one_brick()
    # start thread
    time.sleep(1)
    
    turn_right = lambda brick, power, distance: rotate(brick, LEFT_WHEEL, power,
            distance)
    turn_left = lambda brick, power, distance: rotate(brick, RIGHT_WHEEL, power,
            distance)
    #lijst = [(move, 100, 200),(turn_left, 100, 120), (move, 100, 200),
    #        (turn_right, 100, 120)] 
    #lijst = [(move, 100, 200),(turn_left, 100, 180), (move, 100, 200),
    #        (turn_left, 100, 180), (move, 100, 200),(turn_left, 100, 180),
    #        (move, 100, 200)] 
    lijst = [ Rotate(brick, LEFT_WHEEL, 100, 180), Rotate(brick, RIGHT_WHEEL,
        100, 180)]
    position = path(lijst, brick)

if __name__ == "__main__":
    main()
