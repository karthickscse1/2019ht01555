# 2019ht01555
NAME: Venkatesa Babu Sellaiya

BITS ID: 2019ht01555

BITS EMAIL:2019ht01555@wilp.bits-pilani.ac.in

Problem Statement: 

Write a TCL script (file name: question1.tcl) to simulate the network topology shown in Fig.1 in ns-2 simulator. All links are duplex with 2ms delay and DropTail queue. The bandwidth of individual links is mentioned in Fig.1. Use the Session routing policy for all the nodes. Create the UDP and TCP flows with required parameters as per the information mentioned in the Fig.1. Use different colors to designate the three different traffic flows for animation. Enable Nam and trace in the script. Run the simulation with different time intervals to observe the behavior of TCP Reno and TCP Cubic variants.

Deliverables:

The script file named as question1.tcl [it includes procedure to generate congestion.xg and the script for drop packet count]
XGraph for congestion-window-size vs. time of TCP Reno and TCP Cubic (you have to upload one graph file for each TCP variant out of multiple simulation time intervals runs performed.)
observation.txt file
Create a zip file of all deliverables, i.e., question1.tcl, congestionReno.xg, congestionCubic.xg, and observation.txt to upload on TAXILA.


MY ANSWER
==========================================================================================
1. I have coded the procdure in the question1.tcl and named a procedure Plot Window to generatea Congestion.xg using Xgraph utility to plot the TCP Congestion window size with respect to time for TCP Remo and TCP cubic Varients. The graph is plotting with the size of congestion window at every 0.1 seconds.

2. I added scripts to obtain dropped packets count for the TCP Flow and commented it. 

3. I ran the scripts and got outputs. Unfortunately I can't pull any outputs files from my office PCs, and I dont have Linux box in my home. But this script will run for sure. 
