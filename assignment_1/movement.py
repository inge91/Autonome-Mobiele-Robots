import nxt
from pylab import *
from threading import Thread
import time

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


def rotate(brick, power, distance):
    left_wheel = nxt.Motor(brick, nxt.PORT_C)
    right_wheel = nxt.Motor(brick, nxt.PORT_B)

    leftTurner = WheelMover(left_wheel, power, distance, False)
    #rightTurner = WheelMover(right_wheel, -power, distance, False)

    leftTurner.start()
    #rightTurner.start()

    leftTurner.join()
    #rightTurner.join()

def path(brick, tuples):
    for fun, power, distance in tuples:
        fun(brick, power, distance)
        time.sleep(1)
