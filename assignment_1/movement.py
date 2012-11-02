import nxt
from pylab import *
from threading import Thread
import time

LEFT_WHEEL = nxt.PORT_C
RIGHT_WHEEL = nxt.PORT_B

class WheelMover(Thread):
    def __init__(self, motor, power, distance, brake):
        Thread.__init__(self)
        self.power = power
        self.motor = motor
        self.distance = distance
        self.brake = brake

    def run(self):
        self.motor.turn(self.power, self.distance, brake=self.brake)


def move(brick, power, distance):
    left_wheel = nxt.Motor(brick, nxt.PORT_C)
    right_wheel = nxt.Motor(brick, nxt.PORT_B)

    leftMover = WheelMover(left_wheel, power, distance, False)
    rightMover = WheelMover(right_wheel, power, distance, False)

    leftMover.start()
    rightMover.start()

    leftMover.join()
    rightMover.join()


def rotate(brick, port, power, distance):
    wheel = nxt.Motor(brick, port)

    turner = WheelMover(wheel, power, distance, False)

    turner.start()

    turner.join()

def path(brick, tuples):
    for fun, power, distance in tuples:
        fun(brick, power, distance)
        time.sleep(1)

def main():
    # find a brick
    brick = nxt.find_one_brick()

    turn_right = lambda brick, power, distance: rotate(brick, LEFT_WHEEL, power,
            distance)
    turn_left = lambda brick, power, distance: rotate(brick, RIGHT_WHEEL, power,
            distance)
    #lijst = [(move, 100, 200),(turn_left, 100, 120), (move, 100, 200),
    #        (turn_right, 100, 120)] 
    lijst = [(move, 100, 200),(turn_left, 100, 180), (move, 100, 200),
            (turn_left, 100, 180), (move, 100, 200),(turn_left, 100, 180),
            (move, 100, 200)] 
    path(brick, lijst)
if __name__ == "__main__":
    main()
