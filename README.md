# Implementation of Control Systems

This repository contains the code used during the course. This README file will guide you through the execution of the code and the (common part of the) assignments. The code contains three different examples (a simple warmup exercise and two exercises on the control of a [Furuta pendulum](https://en.wikipedia.org/wiki/Furuta_pendulum)).

The purpose of the course is to analyse (some of) the effects of computation on the execution of control systems. In particular, we are going to look at **sampling periods**, **computational delays**, and **actuator saturations**. We are going to use MATLAB for our analysis.

For all the examples we will synthesise controllers. Example solutions are provided in the material; note that the solutions are _not_ optimised and there is (certainly) room for improvement.

Let's dive into the `code` folder. All the examples use common files, provided in the folder `base`. The other folders contain the examples code. For each of the examples, a `run.m` script that is used to execute the corresponding simulation. Other files are provided: a file that contains the specification of the `dynamics` of the system to be controlled, a file that contains the specification of the `output` and a file that contains the specification of the `setpoint`.

## 1. Simple example

This is a warmup exercise, to familiarise ourselves with the code structure. In this simple example we should control a second-order linear (unstable) system.

1. Navigate to the folder `code/simple_example/`.
2. Execute `run`.
3. You will see a figure popping up, with three plots: the top plot shows the value of the output `y` and the setpoint `r`, the middle plot shows the states of the system `x1` and `x2`, the bottom plot shows the control signal (vertical lines indicate the start of each control period).
4. In the MATLAB environment, you will see the result of the variable `perf` (1.0030), this is a possible performance metric (the sum of the squared error on the entire trace divided by the trace length) to evaluate how good your controller is (for this specific example and in this specific case, do not try to infer too much generality): lower numbers are better.

What you see in the figure is the result of the execution of the controller solution that is provided with the exercise, `pi_sol_simple`. The (obfuscated) file contains the implementation of a proportional and integral controller for the second order system. The setpoint for the system is set to 4 at time 0 and changed to 1 at time 2.5. The output signal slowly reaches the desired value.

In the file `run.m`, the controller is selected on line 18 (`c = @pi_sol_simple;`). Instead of executing the provided solution, modify this line to point to your own controller (`pi_simple.m` - a skeleton for the controller is provided).

* **Task 1a**: Implement a proportional and integral (PI) controller for the system in `pi_simple.m`. For the control design part, check the files `dynamics_simple.m` and `output_simple.m` where you can find the matrices `A, B, C, D` for the system we are simulating. The controller already includes control signal saturation limits (lines 4 and 5 in `pi_simple.m`). Make sure your controller does not produce control signals that are outside of the valid range.
* **Task 1b**: Now suppose your actuator does _not_ accept values outside of the range `[-10,10]`. Modify your controller code accordingly and check what happens in the simulation.
* **Task 1c**: On line 13 of `run.m` you find the variable `controller_period`. This determines how frequently the controller is executed. When you change the controller period, what happens to the output? How does the period relate to the PI controller gains?
* **Task 1d**: On line 14 of `run.m` you find the variable `computational_delay`. This sets a deterministic delay for the controller code response time (how long from the period start to the moment in which the control signal is produced). Initially, the delay is set to zero (meaning that we are running in ideal conditions and the computation is instantaneous). The variable can take any value between 0 and `controller_period` (in principle, it could take longer to compute the control signal, but we are not discussing this case here). If you have a non-zero computational delay, in the figure, the delay is going to be represented by dashed vertical lines, that exactly show you when the new control signal is available.

## 2. Furuta pendulum linearisation

For the following two tasks we are going to use the model of a Furuta pendulum (see [this video](https://www.youtube.com/watch?v=XKzzWe15DEw) for an idea of what it looks like). The hardware has an arm that rotates; the rotation of the arm makes a pendulum swing. We can write a non-linear model for the pendulum. This model has two equilibrium points: the downright and the upright position. The downright position corresponds to a stable equilibrium, while the upright position is an unstable equilibrium. The control objective is usually to stabilise the pendulum around the upright position (keeping the pendulum upright).

1. Navigate to the folder `code/furuta_pendulum_linearisation/`.
2. Execute `run`.
3. You will see that `perf=0.0229` and a plot with the same structure as the one for the simple example.

In the `doc` folder you can find a PDF (modelling_furuta_pendulum.pdf) that shows the derivation of a model for the pendulum. Using the notation of the report, &theta; is the angle between the upright position and the current pendulum position. The control objective is therefore to have &theta;=0. Section 7 in the report derives a linearised model for the pendulum behaviour, that is valid around the equilibrium point. We are for now ignoring how to drive the pendulum position close to the equilibrium point.

* **Task 2a**: The first task is to write a controller that keeps the pendulum in the upright position when the pendulum is already close to it. Suppose somebody is holding the pendulum at the start such that the angular velocity of the pendulum is zero (and the arm is completely still with position zero and angular velocity zero). This corresponds to an initial state `x = [0; 0; p; 0]` where p is the initial angle &theta; (in `run.m` p=0.5). The linearised model is already implemented in `dynamics_furuta_linearisation.m`. In `run.m` change line 26 to point to your controller (`ctl_linearisation`) and write the code for a controller that drives the pendulum angle to zero and keeps it at zero.
* **Task 2b**: If you start from a different initial position, your controller should still work (make sure you understand why and why this is not the case when you run the same controller on the real system - this should be obvious at this point).
* **Task 2c**: What happens when you change the sampling period of the controller and its computational delay (lines 21 and 22)? Make sure you can stabilise the pendulum with realistic computational delays (e.g., if you are executing every 10ms - the initial value -, then try what happens when the control signal computation to take up to 5ms).

## 3. Furuta pendulum

In this last task, we will design a simple heuristic for the swing up of the pendulum.

1. Navigate to the folder `code/furuta_pendulum/`.
2. Execute `run`.
3. You will see that `perf=1.2095` and a plot with the same quantities as the previous example.

The initial position in this case is set (line 17 of `run.m`) to `x0 = [0; 0; pi; 0];`. This means that the pendulum is starting from a halt in the downright position. In `dynamics_furuta.m` you can see that the model we are using now is not linear and represents (at a finer level of the detail) the behaviour of the pendulum (it is still an ideal model, e.g., it has no friction).

* **Task 3a**: Copy the code of the controller you developed in the previous step (`ctl_linearisation.m`) into the controller you are developing for the full process (`ctl_withswingup_sat05.m`). Change the controller handler from `ctl_sol_withswingup_sat05` to your controller in line 26 of `run.m` and change the initial state of the controller in accordance to what the format of your controller wants (line 19 in `run.m`). In particular, so far we have developed controllers with a single state variable, so to try to execute your previously designed controller you will need `z0` to be a uni-dimensional vector. Execute your controller and check how it performs.
* **Task 3b**: Your controller was working only around the equilibrium point, but now our initial condition is not around the equilibrium point any longer. We need therefore to design a controller that will take the system state near the equilibrium point such that we can then start controlling the pendulum position using the controller developed for our linearised model. We are therefore designing a swing-up controller. Change the controller behaviour to perform a swing up and then stabilise the pendulum in the upright position. You can design the swing up controller with whichever method you prefer (the solution files are based on a simple heuristic that is designed around the trajectory of Figure 4 of the paper swingup_furuta_pendulum.pdf in the `doc` folder). Ensure that your control signal respects the saturation values provided in `ctl_withswingup_sat05.m`, meaning that u should be in the range `[-0.5,0.5]`.
* **Task 3c**: Suppose now that you got a better hardware, that is able to handle a wider range of control signals. We now introduce new limits and our control signal should belong to the interval `[-0.75,0.75]`. What changes in the controller? Code up your solution in `ctl_withswingup_sat075.m`, switch to the new controller handler in `run.m` and execute the controller. Does the performance get better? For reference, the provided solution achieves `perf=0.7265`.
* **Task 3d**: For both the controllers that you developed, investigate what happens when you change period and computational delay. What are the limits of your designs?

Bonus: once you have performed a simulation, you can run the function `animate_trajectory(t, x)` to see an animation showing the pendulum behaviour.
