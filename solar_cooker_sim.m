function [T, M] = solar_cooker_sim(cooker_radius)

    function res = rate_func(~, X)
        diff_temp_in_out_pot = ;
        U_cond = d_pot/(k_pot*A_cross_pot) * diff_temp_in_out_pot;
        diff_temp_pot_air = ;
        res(1) = e*I*A_proj_cooker - 1/(h_air * A_outer_pot)*diff_temp_pot_air - U_cond;
        diff_temp_water_in_pot = 
        U_conv_inner_pot = 1/(h_water*A_inner_pot) * diff_temp_water_in_pot;
        res(2) = U_cond - U_conv_inner_pot;
        res(3) = U_conv_inner_pot + e*I*A_top_pot - 1/(h_air * A_inner_pot);
    end
end