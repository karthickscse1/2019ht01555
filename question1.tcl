# As Asked in the question Enabling Nam and trace in the script and are defined first
set namfile     out.nam
set tracefile   out.tr

#Creating a ns simulator object
set ns [new Simulator]

#Defining different colors for data flows (for NAM) to designate the three different traffic flows for animation.
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

# Setting TCP Variant and TCP Reno and TCP Cubic as asked
set TCP_Variant "Agent/TCP/Linux"
#set TCP_Name "cubic"
set TCP_Name "reno"

set MSS 2048

#Defining monitor procedure
proc monitor {interval} 
{
    global tcp1 ns tcpsink1
    set nowtime [$ns now]

    set win [open result a]
    set bw1 [$tcpsink1 set bytes_]
    #set tput [expr $bw1/$interval*8/1000000]
    set cwnd [$tcp1 set cwnd_]
    #puts $win "$nowtime $tput $cwnd]"
    puts $win "$nowtime $cwnd"
    $tcpsink1 set bytes_ 0
    close $win
    $ns after $interval "monitor $interval"
}

#Write a procedure in the question1.tcl named as plotWindow to generate a graph (congestion.xg) using Xgraph utility 
#to plot the TCP congestion window size with-respect-to time for TCP Reno and TCP cubic variants. 
#Plot the size of congestion window at every 0.1 second interval of time.
#Answering  this here

proc plotWindow {} {
	global ns nf f namfile
	$ns flush-trace
  #closing the NAM Trace file
	close $nf
	close $f

	puts "Eecuting NAM on the trace File: out.nam..."
	#exec nam $namfile


	exec cp result congestionReno.xg
#	exec cp result congestionCubic.xg

	exec xgraph -bg green -fg blue congestionReno.xg -t "TCP cwnd" -x "time (milli seconds)" -y "cwnd size (bytes)" -geometry 800x400 &
#	exec xgraph -bg green -fg blue congestionCubic.xg -t "TCP cwnd" -x "time (milli seconds)" -y "cwnd size (bytes)" -geometry 800x400 &

#Write a script/commands to obtain dropped packets count for the TCP flow. Add this script/commands at the end of the question1.tcl file and comment it.
# Code to count the number of dropped packets in tcp flow (Commented now)

	#puts "Number of dropped packets for the tcp flow"
	#exec gawk -f get_drop_packets.awk out.tr &

	exit 0
}

# open trace files and enable tracing
set nf [open $namfile w]
$ns namtrace-all $nf
set f [open $tracefile w]
$ns trace-all $f

# Defining nodes as per given topology
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

#All links are duplex with 2ms delay and DropTail queue

# creating link (n0-n2)
$ns duplex-link $n0 $n2 1Mb 2ms DropTail

# creating link (n1-n2)
$ns duplex-link $n1 $n2 1Mb 2ms DropTail

# creating link (n2-n3)
$ns duplex-link $n2 $n3 700Kb 2ms DropTail

# creating node and link (n4-n3)
$ns duplex-link $n4 $n3 1Mb 2ms DropTail

# creating two nodes (n3-n5)
$ns duplex-link $n3 $n5 700Kb 2ms DropTail

# creating two nodes (n5-n6)
$ns duplex-link $n5 $n6 1Mb 2ms DropTail

# creating two nodes (n5-n7)
$ns duplex-link $n5 $n7 1Mb 2ms DropTail

#no queue limit, disabling it 
#$ns queue-limit $n0 $n1 10

#no Orientation, disabling it
#$ns duplex-link-op $n0 $n2 orient right-dow

# Define Routing policy as Session

$ns rtproto Session

# create FullTcp agents for the nodes (n1 - n6)
# TcpApp needs a two-way implementation of TCP
# TCP variant used is cubic

set tcp1 [new $TCP_Variant]

$ns at 0 "$tcp1 select_ca $TCP_Name"

#no need to set class
#$tcp set class_ 2

$tcp1 set packetSize_ $MSS

# Setting Blue color for tcp1 flow
$tcp1 set fid_ 0

$ns attach-agent $n1 $tcp1

set tcpsink1 [new Agent/TCPSink]
$ns attach-agent $n6 $tcpsink1

$ns connect $tcp1 $tcpsink1

#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]

$ftp1 attach-agent $tcp1

#Creating UDP Flows between n0 and n7 and n4 and n7

#Create a UDP agent and attach it to node n0
set udp1 [new Agent/UDP]

# Setting Red color for udp1 flow
$udp1 set fid_ 1

$ns attach-agent $n0 $udp1

#Creating a Null agent (a traffic sink) and attach it to node n7
set udpsink1 [new Agent/Null]
$ns attach-agent $n7 $udpsink1

#Connecting the traffic source with the traffic sink
$ns connect $udp1 $udpsink1

#Creating a UDP agent and attach it to node n4
set udp2 [new Agent/UDP]

# Setting green color for cbr2 flow
$udp2 set fid_ 2

$ns attach-agent $n4 $udp2

#Creating a Null agent (a traffic sink) and attach it to node n7
set udpsink2 [new Agent/Null]
$ns attach-agent $n7 $udpsink2

#Connecting the traffic source with the traffic sink
$ns connect $udp2 $udpsink2

#as Asked in the question:
# Creating a UDP CBR traffic source 1 and attaching it
#UDP Source 1
#CBR Traffic
#Packet Size = 500 Bytes
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

#as Asked in the question:
# Creating a UDP CBR traffic source 2 and attaching it
#UDP Source 2
#CBR Traffic
#Packet Size = 500 Bytes
# Create a CBR traffic source and attach it to udp2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005
$cbr2 attach-agent $udp2


#Scheduling FTP for TCP agent as asked in the question
#starting at 1 sec
#run0
puts "Run 0 at 1 Sec and Stopping at 19 sec.."
$ns at 1 "$ftp1 start"
$ns at 19 "$ftp1 stop"

#Scheduling events for the CBR agent
#starting at 8 sec

#run1
puts "Run 1 at 8 Sec and Stopping at 13 sec.."
$ns at 8 "$cbr1 start"
$ns at 13 "$cbr1 stop"

#run2
puts "Run 1 at 1 Sec and Stopping at 13 sec.."
#$ns at 1 "$cbr1 start"
#$ns at 13 "$cbr1 stop"

#run3
puts "Run 1 at 0 Sec and Stopping at 12 sec.."
#$ns at 1 "$cbr1 start"
#$ns at 12 "$cbr1 stop"

#Schedule events for the CBR agent
#run4
puts "Run 4 at 8 Sec and Stopping at 13 sec.."
$ns at 8 "$cbr2 start"
$ns at 13 "$cbr2 stop"

#run5
puts "Run 5 at 0 Sec and Stopping at 13 sec.."
#$ns at 0 "$cbr2 start"
#$ns at 13 "$cbr2 stop"

#run6
puts "Run 5 at 9 Sec and Stopping at 18 sec.."
#$ns at 9 "$cbr2 start"
#$ns at 18 "$cbr2 stop"

puts "Detaching tcp and sink agents (not really necessary).."
#Detaching tcp and sink agents (not really necessary)
#$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink"

puts "Not closing the finish procedure.."
#Call the finish procedure after 15 seconds of simulation time
#$ns at 15.0 "finish"

#Plotting the size of congestion window at every 0.1 second interval of time
$ns at 0 "monitor 0.1"

$ns at 22.0 "plotWindow"

#Print CBR packet size and interval
#puts "CBR packet size = [$cbr2 set packet_size_]"
#puts "CBR interval = [$cbr2 set interval_]"

#Run the simuation
$ns run
