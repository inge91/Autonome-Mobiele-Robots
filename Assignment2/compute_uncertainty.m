function sigma_dist = compute_uncertainty( rho, sigma_rho, alpha, height );

% sigma_dist = compute_uncertainty( rho, sigma_rho, alpha, height )
%
% Computes the error of the distance on the ground floor, given the error
% of the distance in the image plane using the camera model.


%--------------------------------------------------------------------------

deriv_dp_p = (height / alpha) * (1 + tan(rho / alpha).^2);
sigma_dist = deriv_dp_p * sigma_rho;

%--------------------------------------------------------------------------
