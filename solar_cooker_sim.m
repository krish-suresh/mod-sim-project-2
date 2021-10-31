function [T, M] = solar_cooker_sim(cooker_radius)
    pot_radius = 8/100;
    pot_height = 8/100;
    pot_thickness = 0.5/100;
    h_water = 250;
    h_air = 25;
    air_temp = 270;
    A_top_pot = (pot_radius)^2 * pi;
    A_inner_pot = (pot_radius)*2*pi*pot_height + A_top_pot;
    A_outer_pot = (pot_radius+pot_thickness)*2*pi*pot_height + (pot_radius+pot_thickness)^2*pi;
    A_proj_cooker = cooker_radius^2 * pi;
    V_water = A_top_pot*(pot_height-pot_thickness);
    V_pot = (pot_radius+pot_thickness)^2*pi*pot_height - V_water;
    rho_pot = 8050;
    rho_water = 1000;
    e_pot = 0.5;
    e_water = 0.5;
    I = 4500;
    m_pot = rho_pot*V_pot;
    c_pot = 490;
    m_water = rho_water*V_water;
    c_water = 4186;
    function res = rate_func(~, X)
        res = zeros(2, 1);
%         diff_temp_in_out_pot = 6;
%         U_cond = d_pot/(k_pot*A_cross_pot) * diff_temp_in_out_pot;
%         diff_temp_pot_air = 6;
%         res(1) = e*I*A_proj_cooker - 1/(h_air * A_outer_pot)*diff_temp_pot_air - U_cond;
%         diff_temp_water_in_pot = 5;
%         U_conv_inner_pot = 1/(h_water*A_inner_pot) * diff_temp_water_in_pot;
%         res(2) = U_cond - U_conv_inner_pot;
%         res(3) = U_conv_inner_pot + e*I*A_top_pot - 1/(h_air * A_inner_pot);
        pot_temp = energyToTemperature(X(1), m_pot, c_pot);
        water_temp = energyToTemperature(X(2), m_water, c_water);
        diff_temp_pot_air = air_temp - pot_temp;
        U_conv_water = 1/(h_water*A_inner_pot) * (water_temp - pot_temp);
        res(1) = e_pot*I*A_proj_cooker - 1/(h_air * A_outer_pot)*diff_temp_pot_air - U_conv_water;
        res(2) = U_conv_water + e_water*I*A_top_pot - 1/(h_air * A_inner_pot)*(air_temp - water_temp);
    end


    U_pot_0 = temperatureToEnergy(air_temp, m_pot, c_pot);
    U_water_0 = temperatureToEnergy(air_temp, m_water, c_water);
    t_0 = 0;
    t_end = 30*60;
    [T, M] = ode45(@rate_func, [t_0, t_end], [U_pot_0; U_water_0]);
end