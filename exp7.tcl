set opt(chan) Channel/WirelessChannel ;
set opt(prop) Propagation/TwoRayGround ; 
set opt(netif) Phy/WirelessPhy ;
set opt(mac) Mac/802_11 ;
set opt(ifq) Queue/DropTail/PriQueue ;
set opt(ll) LL ;
set opt(ant) Antenna/OmniAntenna ;
set opt(ifqlen) 50 ;
set opt(adhocRouting) AODV;


set ns [new Simulator]
set name [lindex [split [info script] "."] 0]
set tracefd [open $name.tr w]
set namtrace [open $name.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace 650 400
set topo [new Topography]


#set ns [new Simulator]
#set name [lindex [split [info script] "."] 0]
#set tracefile [open $name.tr w]
#$ns trace-all $tracefile
#set namfile [open $name.nam w]
#$ns namtrace-all-wireless $namfile 650 400 #wireless

set topo [new Topography]
$topo load_flatgrid 650 400
create-god 4

set chan1 [new $opt(chan)]
$ns node-config -adhocRouting $opt(adhocRouting) \
		-llType $opt(ll) \
		-macType $opt(mac) \
		-ifqType $opt(ifq) \
		-ifqLen $opt(ifqlen) \
		-antType $opt(ant) \
		-propType $opt(prop) \
		-phyType $opt(netif) \
		-channel $chan1 \
		-topoInstance $topo \
		-wiredRouting OFF \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace OFF
#node creation
#for {set i 0} {$i < 4} {incr i} {
#set node($i) [$ns node]
#$node($i) set Z_ 0
#}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]



$n0 set Y_ 300
$n0 set X_ 100
$n0 set Z_ 0

$n1 set Y_ 100
$n1 set X_ 100
$n1 set Z_ 0

$n2 set Y_ 200
$n2 set X_ 250
$n2 set Z_ 0

$n3 set Y_ 200
$n3 set X_ 400
$n3 set Z_ 0



set tcp0 [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n3 $sink
$ns connect $tcp0 $sink
$tcp0 set packetsize_ 500
$tcp0 set interval_ 0.005
$tcp0 set class_ Blue


set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set udp1 [new Agent/UDP]
set null3 [new Agent/Null]
$ns attach-agent $n1 $udp1
$ns attach-agent $n3 $null3
$ns connect $udp1 $null3
$udp1 set packetsize_ 500
$udp1 set interval_ 0.005

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1


$ns initial_node_pos $n0 20
$ns initial_node_pos $n1 20
$ns initial_node_pos $n2 20
$ns initial_node_pos $n3 20

$ns at 0.0 "$n0 setdest 5.0 15.0 2.0"
$ns at 0.0 "$n1 setdest 5.0 385.0 2.0"
$ns at 0.0 "$n2 setdest 100.0 195.0 2.0"
$ns at 0.0 "$n3 setdest 300.0 195.0 2.0"
$ns at 50.0 "$n2 setdest 100.0 15.0 20.0"
$ns at 100.0 "$n2 setdest 100.0 385.0 20.0"
$ns at 150.0 "$n2 setdest 100.0 195.0 20.0"



$ns at 1.1 "$ftp0 start"
$ns at 1.1 "$cbr1 start"
$ns at 200.1 "$ftp0 stop"
$ns at 200.1 "$cbr1 stop"
$ns at 201.1 "finish"


proc finish {} {
#extra name variable
	global ns tracefd namtrace name
	$ns flush-trace
	close $tracefd
	close $namtrace
	exec nam $name.nam &
	exec awk -f exp7.awk $name.tr > outputexp7.dat &
	exit 0
}
$ns run



































