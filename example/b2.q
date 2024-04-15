/ input
.b2I.MessageType:times[3;nT];
.b2I.DestinationAddress:times[12;xT];
.b2I.Priority:opt oneof"SUN";
.b2I.DeliveryMonitoring:opt oneof"123";
.b2I.ObsolescencePeriod:opt plus .(str')("003";"020");

/ output
.b2O.MessageType:times[3;nT];
.b2O.InputTime:hhmm;
.b2O.MIR:seqA yymmdd,(reify times[12;cT]),(toj')times[4;nT],times[6;nT];
.b2O.OutputDate:yymmdd;
.b2O.OutputTime:hhmm;
.b2O.Priority:opt oneof"SUN";
