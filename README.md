# mod-sim-project-2
Project 2 - Solar Cooker
Gia-Uyen Tran and Krishna Suresh; November 3, 2021
Question
In remote areas such as the Himalayas, cheap and readily available cooking methods are essential. One such solution is a solar cooker, a paraboloid with a reflective inner surface that harnesses the sun’s energy. 

(https://solarcooking.fandom.com/wiki/SK12)
One property of paraboloids is that when light enters normal to its open circular face, it will always be reflected back to a point called the focus. 

(https://courses.lumenlearning.com/ivytech-collegealgebra/chapter/solving-applied-problems-involving-parabolas/)
Design Question: 
Keeping solar cooker depth constant, what is the minimum radius paraboloid to boil water within a time constant?
This is a design question because it is regarding the variation in parameters that influence the shape of the solar cooker. Our primary motivation behind finding the minimum radius lies with the critical consideration of cost when designing a device to be used by an impoverished region. By minimizing radius we implicitly are looking for the lowest cost solar cooker that can still be feasible for cooking.
Method
In this model, the sun is the energy source. The sun’s rays are assumed to enter the solar cooker perpendicular to its open circular face and reflect perfectly (i.e. there is no energy loss) off of the paraboloid. Because of the unique properties of a paraboloid, these rays reflect to a point known as the focus, which is where the pot of water will be located. The pot itself is made from 2mm thick stainless steel (this material was chosen because of its abundance and affordability) with an interior diameter of 8cm and height of 8cm. The pot does not have a lid, so the top surface of the water will be exposed. These parameters were chosen to represent a standard small pot. The figure below shows a diagram of the model.

The radiation is reflected off the solar cooker to heat the stainless steel pot via radiation, which then heats the water via convection. The pot itself blocks sunlight from reflecting, but we do not account for that in this model. Furthermore, solar cookers are typically constructed in small segments that collectively resemble the shape of a paraboloid, so they are in reality not an exact continuous parabolic surface. Note that the pot in this model is considered to be one thermal mass, so the conduction between the outer and inner surfaces are not taken into account. 
Model Iteration
One iteration we made in our model was to include the heat loss. The system also loses thermal energy through two processes: the convection between the pot and surrounding air in addition to the convection between the exposed water and surrounding air. Additionally, note that the heat loss due to evaporation is not represented in this model. 
Stock and Flow Diagram

In order to represent this model mathematically, we used a few fundamental equations relating to heat transfer. The following variables have been adjusted to reflect the environmental impacts of a Himalayan setting (altitude = 3000m). The weather was assumed to be static, environmental factors such as changes in temperature, clouds that obscure sunlight, and the possibility of wind were not accounted for.
Mathematical Representation
The heat transfer per unit of time for convection is

where h is the convection coefficient, A is the area of convection, and T is the difference in temperature.
The heat transfer per unit of time for radiation is

where e is the efficiency of absorption, I is insolation, and A_proj is the effective area.
We can combine these equations to get differential equations for our stocks. The pot energy stock (P) is influenced by radiation from the sun, convection with the surrounding air, and convection with the water. The change in pot thermal energy per unit of time can be represented as:


The water thermal energy stock (W) is influenced by radiation from the sun, convection with the pot, and convection with the surrounding air. The change in water thermal energy per unit of time can be represented as:


The equations use the following variables:
e_p is the efficiency of absorption of the pot (1)
e_w is the efficiency of absorption of the water (1)
I is insolation at 3000m (2)
A_proj is the effective area of the object receiving radiation
h_w is the convective coefficient for water (3)
h_a is the convective coefficient for air (3)
A_i is the surface area of the inner pot
A_o is the surface area out the outer pot
Delta_T is the difference in temperatures
Programmatic Representation 
This process can be modeled with the function solar_cooker_sim, which takes the radius of a paraboloid as its input and outputs three things:
T, a vector with the times chosen by ode45
M, a matrix with columns for the temperature of the pot (column 1) and the water (column 2) at each timestep
boil_time, the  time in minutes that it would take for that solar cooker to bring the water in the pot to a boil (363 K).
The solar_cooker_sim function uses a rate function to represent the change in energy of the pot and water. Then uses ode45 to estimate the function value over time and finally output the time the water reaches the boiling point.
Example solar cooker with a radius of 0.6 meters simulated over 120 minutes:
clf
[T, M, boil_time] = solar_cooker_sim(0.6); % simulate the change in temp of water and the pot over 120 minutes
plot(T, M(:,2))
ylabel("Temperature (K)")
xlabel("Time (min)")
title("Temperature change of pot of water on a 0.6m radius solar cooker")
[Radiation eqn] indicates that the projected area of the parabola is significant. Differing depths with the same radius would have the same projected area, so it would not impact the total energy from radiation. Consequently, this model holds depth as a constant 0.5 meters (chosen to be relatively proportional to the radius sweep) while changing radius.

Parameter Sweep
We can now parameter sweep radius values. The radii values were chosen such that the focus was at most half a meter above the largest circular cross section of the paraboloid. The intention was to model a reasonable solar cooker design. While it would be possible to have a focus further out, it would become increasingly difficult to build a stable platform to hold the pot. Additionally, the focus was at least 10 centimeters away from the bottom of the cooker to ensure that the pot (8cm tall) would fit. With these guidelines in mind, the radius values were swept ranging from 0.5m to 1.5m incrementing by 0.01m each time.

clear
sweep_range=0.5:0.01:5; % range of radius to sweep across
J = zeros(size(sweep_range, 2), 2);
for i=1:length(sweep_range)
    [T, M, boil_time] = solar_cooker_sim(sweep_range(i)); % simulate for a specific radius
    J(i,:) = [sweep_range(i), boil_time];
end
J % Data relating radius and time to boil
Material Cost of Solar Cooker
In order to find the material cost of a solar cooker, we first abstracted the volumetric shape of a paraboloid shell to a two dimensional surface. This corresponds to a cost calculation of sheets being per square meter. Using this abstraction, we calculated the surface area of the paraboloid by rotating a parabola around the y axis. 
Finding Material Cost of Solar Cooker
In order to find the material cost of a solar cooker, we first abstracted the volumetric shape of a paraboloid shell to a two dimensional surface. This corresponds to a cost calculation of sheets being per square meter. Using this abstraction, we calculated the surface area of the paraboloid by rotating a parabola around the y axis. 

The paraboloid_radius_to_cost function numerically calculates this integral to find the inner surface area of the solar cooker from 3 parameters:
Radius in meters
Depth of solar cooker in meters
Cost per square meter in dollars
It then multiplies this area by the cost per square meter to find an approximate cost to produce each paraboloid. 
Cost per square meter
Through research of common solar cooker reflective materials we found that mylar is a standard surface with a high reflectivity. The estimated cost in US dollars per square meter is 1.5 (amazon citation).
cost_per_sq_m = 1.5 % in $/m^2

Below is a sweep displaying this relationship between cost and radius of the solar cooker, but we will only be using this to find the cost of one solar cooker. This cost is representative of the surface material, but we are treating the rest of the solar cooker as a proportional cost to this surface material cost.
figure(3)
sweep_range=0.5:0.01:1.5; % sweep range
K = zeros(size(sweep_range, 2), 2);
for i=1:length(sweep_range)
     cost = paraboloid_radius_to_cost(sweep_range(i), 0.5, cost_per_sq_m); % finding cost of a paraboloid for a specific radius and fixed height 
     K(i,:) = [sweep_range(i), cost];
end
plot(K(:,1), K(:,2))
xlabel("Radius (m)")
ylabel("Cost (dollars)")
title("Solar cooker cost vs radius with a fixed height")
Results
figure(2)
sweep_range=0.5:0.01:1.5; % sweep range
K = zeros(size(sweep_range, 2), 2);
for i=1:length(sweep_range)
    [T, M, boil_time] = solar_cooker_sim(sweep_range(i)); % simulation with a specfic radius
    K(i,:) = [sweep_range(i), boil_time];
end
time_constrain = 15;
[min_time, min_radius_ind] = min(K(1:find(K(:,2) < time_constrain, 1),2)); % finding the radius which boils water closest to 15 minutes
min_radius = K(min_radius_ind,1)
clf
hold on
plot(K(:,1), K(:,2))
xline(min_radius);
yline(min_time);
xlabel("Radius (m)")
ylabel("Time (min)")
title("Time to boil for a range of radii")
The above sweep across radii illustrates the change in time to boil as we increase the radius of the solar cooker. With a time constraint of 15 minutes, a solar cooker with a radius of X meters is the minimum size to heat water to a temperature of 363 K. However, we do find that as we lower our time constraint the change in radius dramatically increases with incremental temperature changes. Therefore, our representation of the relationship between time to boil and radius is only relevant in the ranges leading up to the asymptotic end condition of the model.
Next, we applied the conversion between radius and predicted cost to find a dollar amount of $3.53 calculated from the surface area of the solar cooker. 
cost = paraboloid_radius_to_cost(min_radius, 0.5, cost_per_sq_m)
Interpret
Overall, our results indicate water boiling times that fit the realm of reasonability and indicate a trend that is similar to the asymptotic diminishing returns we inferred would occur. Some key considerations that we found to break our representation of this system include the evaporation of water, reflection efficiency, and pot conduction. Since water will change phase at the point of boiling and carry away energy through the molecules leaving the mass, the carrying capacity of heat is much lower than what our model displays when run over long periods of time. Additionally, our assumption of perfect reflection of radiation skews our boiling times to be faster than with a physical test. Finally, we assumed a uniform heat distribution with energy flow into the pot which would more likely follow a model including conduction between the outer and inner surfaces. But, for the purposes of estimating a radius to optimally boil water within a fixed time interval, these factors more so influence the long term or proportional impacts. Therefore, our findings illustrating the non-linear relationship between time to boil and radius of a solar cooker through the high level abstraction of heat flows can effectively find the minimum cost of a solar cooker to boil water within 15 minutes.

References
https://www.engineeringtoolbox.com/solar-radiation-absorbed-materials-d_1568.html
https://energyeducation.ca/encyclopedia/Insolation
https://www.sciencedirect.com/topics/engineering/convection-heat-transfer-coefficient
