import numpy as np
import math

class Odometry:

    #radius of the wheels
    r1 = 28
    r2 = 28

    # The amount of degrees measured
    total_lmeasured = 0
    total_rmeasured = 0

    # The given amount of degrees turned
    total_lreal = 0  
    total_rreal = 0

    def __init__(self):
        print "initialised"

    # Use new rotation counts
    def add_rotations(self, lrotations_measured, rrotations_measured, real_lvalue,
            real_rvalue):
        #add measured to total measured
        self.total_lmeasured += lrotations_measured
        self.total_rmeasured += rrotations_measured
        #add real to total value
        self.total_lreal += real_lvalue
        self.total_rreal += real_rvalue
        print "Total measured: "
        print self.total_lmeasured
        print self.total_rmeasured
        print "Total real values:"
        print self.total_lreal
        print self.total_rreal
        
    # returns tuple for the distance difference in left wheel and right wheel
    def get_difference(self):
        print "total measured",
        print self.total_lmeasured
        print self.total_rmeasured


        print "total real"  
        print self.total_lreal
        print self.total_rreal


        # In mm the real distances.
        l_mm_real = (self.total_lreal / 360.0) * math.pi * (self.r1 * 2)
        r_mm_real = (self.total_rreal / 360.0) * math.pi * (self.r2 * 2)
        print "Real distances in mm"
        print l_mm_real
        print r_mm_real
        # iIn mm the measured distances
        l_mm_measured = (self.total_lmeasured / 360.0) * math.pi * (self.r1 * 2)
        r_mm_measured = (self.total_rmeasured / 360.0) * math.pi * (self.r2 * 2)
        print "Measured distances in mm"
        print l_mm_measured
        print r_mm_measured
        return (abs(l_mm_real - l_mm_measured), abs(r_mm_real - r_mm_measured))
