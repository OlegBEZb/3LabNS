set ns [new Simulator]
#задание динамической модели маршрутизации для всех узлов
$ns rtproto Static

$ns color 1 Blue
$ns color 2 Red

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam
	exit 0
}

set s1 [$ns node]
set s2 [$ns node]
set s3 [$ns node]

set r1 [$ns node]
set r2 [$ns node]
set r3 [$ns node]
set r4 [$ns node]
set r5 [$ns node]

set k1 [$ns node]
set k2 [$ns node]
set k3 [$ns node]

$ns duplex-link $r1 $r2 256kb 20ms DropTail
$ns duplex-link-op $r1 $r2 orient right

$ns duplex-link $s1 $r1 256kb 20ms DropTail
$ns duplex-link-op $s1 $r1 orient right

$ns duplex-link $r1 $s2 256kb 20ms DropTail
$ns duplex-link-op $r1 $s2 orient up

$ns duplex-link $r1 $s3 256kb 20ms DropTail
$ns duplex-link-op $r1 $s3 orient down

$ns duplex-link $r2 $r3 256kb 20ms DropTail
$ns duplex-link-op $r2 $r3 orient right-up

$ns duplex-link $r2 $r5 256kb 20ms DropTail
$ns duplex-link-op $r2 $r5 orient right-down

$ns duplex-link $r3 $k1 256kb 20ms DropTail
$ns duplex-link-op $r3 $k1 orient right-up

$ns duplex-link $r3 $r4 256kb 20ms DropTail
$ns duplex-link-op $r3 $r4 orient right

$ns duplex-link $r4 $k2 256kb 20ms DropTail
$ns duplex-link-op $r4 $k2 orient right

$ns duplex-link $r5 $k3 256kb 20ms DropTail
$ns duplex-link-op $r5 $k3 orient right

$ns duplex-link $r4 $k3 256kb 20ms DropTail
$ns duplex-link-op $r4 $k3 orient down

$ns queue-limit $r1 $r2 10
$ns duplex-link-op $r1 $r2 queuePos 0.5

set snk1 [new Agent/TCPSink]
$ns attach-agent $k1 $snk1

set ftp1 [new Agent/TCP]
$ftp1 set maxcwnd_ 50
$ftp1 set packetSize_ 300
$ns attach-agent $s1 $ftp1
$ns connect $ftp1 $snk1
$ftp1 set fid_ 1
set ftp1 [$ftp1 attach-source FTP]


$ns at 0.5 "$ftp1 produce 300"
$ns at 2.0 "$ns cost $r2 $r3 5"
$ns at 2.0 "$ns cost $r3 $r2 5"
$ns at 2.0 "$ns compute-routes"
$ns at 4.0 "$ns cost $r2 $r3 1"
$ns at 4.0 "$ns cost $r3 $r2 1"
$ns at 4.0 "$ns compute-routes"
$ns at 8.0 "finish"

$ns run

