function res = paraboloid_radius_to_cost(r, h, cost_per_square_m)
    a = (2*h)/(r^2);
    function res = func(x)
        res = 2*pi*sqrt(1+(a*x).^2).*x;
    end
    res = integral(@func, 0, r)*cost_per_square_m;
end