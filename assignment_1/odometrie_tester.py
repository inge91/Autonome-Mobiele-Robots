import numpy as np
import math
import nxt
import time

# For the robot
# r wheel = 28
# l = 6
j2 = 0
length = 0

class Odometry(Thread, brick, time_step):
    def __init__(self):
        Thread.__init__(self)
        # copy brick object
        self.brick = brick
        #wheel radii
        self.r1 = 28
        self.r2 = 28
        
        #j2 matrix
        self.j2 = np.matrix([[r1, 0 ],[0, r2]])

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
        self.j1 =  np.matrix()[[math.sin(alpha1 + beta1), -math.cos(alpha1 + beta1),
            (-length)*math.cos(beta1)],
               [math.sin(alpha2 + beta2), -math.cos(alpha2 + beta2),
                   (-length) * math.cos(beta2)],
               [cos(alpha1 + beta1), sin(alpha1 + beta1) l*math.sin(beta1)]])
        # The beginning position 
        self.x = 0 
        self.y = 0 
        self.theta = 0
        # The beginning I
        self.I = np.matrix([[self.x], [self.y], [self.z]])

    def run(self):
        left_wheel = nxt.Motor(brick, nxt.PORT_C)
        right_wheel = nxt.Motor(brick, nxt.PORT_B)
        while(True):
            # Seep until next measurement
            time.sleep(self.time_step/1000)

            # Get tacho of both wheels
            left_tacho = left_wheel.get_tacho().count()
            right_tacho = right_wheel.get_tacho().count()

            # Calculate the derivative of phi1 & phi2
            phi1 = (self.r1 * pi * left_tacho) / time_step
            phi2 = (self.r2 * pi * right_tacho) / time_step

            # Reset tacho count
            left_wheel.get_tacho().reset()
            right_wheel.get_tacho().reset()
            
            # Rotation matrix constructed using current theta
            R = self.rotate(self.theta)

            # Calculate derivative I
            der_I = np.linalg.inv(R) * np.linalg.inv(j1) * [[phi1], [phi2], [0]]

            
            # Calculate new I
            I = der_I * time_step
            print I
            

    # rotation matrix
    def rotate(self, theta):
        return [[math.cos(theta), math.sin(theta), 0], 
                [-math.sin(theta), math.cos(theta), 0],
                [0, 0 1]]


    j2 = np.matrix([[3,0],[0,3]])


