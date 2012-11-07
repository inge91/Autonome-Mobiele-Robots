import numpy as np
from threading import Thread
import math
import nxt
import time

# For the robot
# r wheel = 28
# l = 6
j2 = 0
length = 0

class Odometry(Thread):
    def __init__(self, brick, time_step, variation = 0):
        Thread.__init__(self)
        # copy brick object
        self.brick = brick
        #wheel radii
        self.r1 = 28
        self.r2 = 28

        # give a smoother
        self.variation = variation
        
        #j2 matrix
        self.j2 = np.matrix([[self.r1, 0 ],[0, self.r2]])
        print "J is",
        print self.j2

        # ength 
        self.length = 60

        # right wheel
        alpha1 = math.pi/2
        beta1 = 0

        # left wheel
        alpha2 = -math.pi/2
        beta2 = math.pi
        
        #the time step
        self.time_step = time_step

        #j1, the constraint matrix
        self.j1 =  np.matrix([[0.5, 0.5, 0],[0, 0, 1],[1/(2.0*self.length),
            -1/(2.0*self.length), 0 ]]) 

        print "j1 is",
        print self.j1
        # The beginning position 
        self.x = 0.0 
        self.y = 0.0 
        self.theta = 0.0
        # The beginning I
        self.I = np.matrix([[self.x], [self.y], [self.theta]])

    def run(self):
        left_wheel = nxt.Motor(self.brick, nxt.PORT_C)
        right_wheel = nxt.Motor(self.brick, nxt.PORT_B)
        # Reset tacho count
        left_wheel.reset_position(False)
        right_wheel.reset_position(False)
        self.total_count_left = 0
        self.total_count_right = 0
        i = 0
        #debug sleeper
        #time.sleep(2)
        while(i <300):
            # Seep until next measurement
            time.sleep(self.time_step/1000)

            # Get tacho of both wheels and reset it as fast as possible
            left_tacho = left_wheel.get_tacho().rotation_count
            left_wheel.reset_position(False)
            right_tacho = right_wheel.get_tacho().rotation_count
            right_wheel.reset_position(False)


            ### Variation smoother added###
            if(abs(left_tacho - right_tacho) < self.variation):
                left_tacho = right_tacho
            print "left_tacho: ",
            print left_tacho
            print "right_tacho: ",
            print right_tacho

            
            # add to total count
            self.total_count_left += left_tacho
            self.total_count_right += right_tacho

            print "total tacho left",
            print self.total_count_left
            print "total tacho right",
            print self.total_count_right

            # Calculate the derivative of phi1 & phi2 (mm/ms)
            #         mm                 degrees            
            phi1 = ((self.r1 * 2) * math.pi * (left_tacho/360.0)) /self.time_step
            phi2 = ((self.r2 * 2) * math.pi * (right_tacho/360.0)) /self.time_step

            print "phi1: ",
            print phi1

            print "phi2: ",
            print phi1

            # Construct phi matrix:
            phi = np.matrix([[phi1], [phi2], [0]])
            print "phi: ",
            print phi


            
            # Rotation matrix constructed using current theta
            R = self.rotate(self.theta)

            print "j1",
            print self.j1

            # Calculate derivative I
            der_I = (np.linalg.inv(R) * self.j1) * phi
            print "der I: ",
            print der_I
            print "theta I",
            print der_I[2,0]



            # Calculate new I
            self.I += (der_I * self.time_step)
            # Still need to increment the theta used to create rotation 
            # matrix
            self.theta = self.I[2,0]
            print "I: ",
            print self.I
            
            i += 1
            

    # rotation matrix
    def rotate(self, theta):
        return [[math.cos(theta), math.sin(theta), 0], 
                [-math.sin(theta), math.cos(theta), 0],
                [0, 0, 1]]




