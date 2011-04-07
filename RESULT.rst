XCORE.com I2C Master Component
..............................................

:Status:  Feature complete

:Maintainer:  Gopalakrishna NL (github: nlgk2001)

The I2C Component provides the ability to write and read the I2C Compatible Slave devices.

Tests and Expected Results
==========================
Clean the workspace and build before running any test.

Test1
-----
Select MASTER_TX, MASTER1 AND SLAVE1 by commenting MASTER2 AND SLAVE2.

Result for Test1
----------------
 
Data transmitted by MASTER1 is received by SLAVE1 and displayed on console. Here there will be extra byte which is a sub-address.
data Len =6,Data = 6, 81 ,40 ,81 ,a1 ,55 .

Test2
-----
Select MASTER_TX, MASTER2 AND SLAVE2 by commenting MASTER1 AND SLAVE1.

Result for Test2
----------------
  
Data transmitted by MASTER2 is received by SLAVE2 and displayed on console. Here there will be extra byte which is a sub-address.
data Len =5,Data = 6, 80 ,40 ,81 ,a0.

Test3
-----
Select MASTER_TX, MASTER1, MASTER2 AND SLAVE1 by commenting SLAVE2.

Result for Test3
----------------
  
Data transmitted by MASTER1 is received by SLAVE1 and displayed on console. Here there will be extra byte which is a sub-address.
data Len =6,Data = 6, 81 ,40 ,81 ,a1 ,55. Even though MASTER2 tries to send data, MASTER2 backs off due to arbitration.

Test4
-----
Select MASTER_TX, MASTER1, MASTER2, SLAVE1 and SLAVE2.

Result for Test4
----------------
  
Data transmitted by MASTER1 is received by SLAVE1 and displayed on console. Here there will be extra byte which is a sub-address.
data Len =6,Data = 6, 81 ,40 ,81 ,a1 ,55. Even though MASTER2 tries to send data to SLAVE2, MASTER2 backs off due to arbitration.

Test5
-----
Comment MASTER_TX, MASTER2, and SLAVE2.

Result for Test5
----------------
  
Data received by MASTER1 from SLAVE1 is displayed on console. Data = 81, 55, 21, 55, 81, 55, 81, 98, 81, 1 

Test6
-----
Comment MASTER_TX, MASTER1, and SLAVE1.

Result for Test6
----------------
  
Data received by MASTER2 from SLAVE2 is displayed on console. Data = 81, 55, 21, 55.

Test7
-----
Comment MASTER_TX and SLAVE2.

Result for Test7
----------------
  
Data received by MASTER1 from SLAVE1 is displayed on console.MASTER2 backs off because of arbitration.
Data = 81, 55, 21, 55, 81, 55, 81, 98, 81, 1.

Test8
-----
Comment MASTER_TX.

Result for Test8
----------------
  
Data received by MASTER1 from SLAVE1 is displayed on console.MASTER2 backs off because of arbitration.
Data = 81, 55, 21, 55, 81, 55, 81, 98, 81, 1.
