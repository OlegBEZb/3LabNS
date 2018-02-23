set ns [new Simulator]

$ns color 1 Blue

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
set r1 [$ns node]
set r2 [$ns node]

$ns duplex-link $r1 $r2 256kb 150ms DropTail
$ns duplex-link-op $r1 $r2 orient right-down

$ns duplex-link $s1 $r1 256kb 150ms DropTail
$ns duplex-link-op $s1 $r1 orient right-up

$ns duplex-link $s1 $r2 256kb 150ms DropTail
$ns duplex-link-op $s1 $r2 orient right
$ns queue-limit $s1 $r2 10

set snk [new Agent/TCPSink]
$ns attach-agent $r2 $snk

set ftp [new Agent/TCP]
$ftp set maxcwnd_ 50
$ftp set packetSize_ 200
$ns attach-agent $s1 $ftp
$ns connect $ftp $snk
$ftp set fid_ 1
set ftp1 [$ftp attach-source FTP]

$ns at 0.1 "$ftp1 produce 70"
$ns rtmodel-at 2.0 down $s1 $r2
$ns rtmodel-at 3.0 up $s1 $r2
$ns at 6.0 "finish"

$ns run

