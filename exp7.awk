BEGIN{
datatcp= 0
dataudp= 0
starttimetcp= 400
endtimetcp= 0
starttimeudp= 400
endtimeudp= 0
}
{
#at $3 put single equal sign only.
if($1 == "r" && $3 = "_3_" && $7 =="tcp")
	{
	if(starttimetcp > $2)
		starttimetcp=$2
	endtimetcp = $2
	datatcp = datatcp+$8
	}

if($1 == "r" && $3 = "_3_" && $7 =="cbr")
	{
	if(starttimeudp > $2)
		starttimeudp = $2
	endtimeudp = $2
	dataudp = dataudp+$8
	}
}

END{
throughputtcp=datatcp*8/((endtimetcp-starttimetcp)*1024)
throughputudp=dataudp*8/((endtimeudp-starttimeudp)*1024)
printf("TCP Throughput :: %f kbps\n",throughputtcp) 
printf("UDP Throughput ::%f kbps\n",throughputudp)
printf("TCP Start time: %f\n",starttimetcp)
printf("TCP End time: %f\n",endtimetcp)
printf("UDP Start time: %f\n",starttimeudp)
printf("TCP Start time: %f\n",endtimeudp)
}
