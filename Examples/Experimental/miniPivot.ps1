ipmo ./powershellpivot.psd1 -force

$data = ConvertFrom-Csv @" 
"Region","Item","UnitSold","UnitCost"      
"South","Banana","54","0.46"               
"West","Banana","74","0.56"                
"West","Apple","26","0.7"                  
"East","Banana","38","0.26"                
"East","Kale","71","0.69"                  
"East","Apple","35","0.55"                 
"East","Potato","48","0.48"                
"West","Banana","59","0.49"                
"West","Potato","56","0.62"                
"North","Apple","40","0.68"                
"South","Pear","39","0.44"                 
"West","Banana","60","0.64"                
"West","Pear","32","0.29"                  
"North","Kale","55","0.35"                 
"West","Apple","73","0.26"                 
"South","Potato","33","0.46"               
"West","Banana","49","0.59"                
"West","Pear","65","0.35"                  
"North","Banana","33","0.31"               
"East","Kale","41","0.74"                  
"South","Banana","49","0.31"               
"West","Apple","60","0.34"                 
"South","Apple","38","0.59"                
"North","Pear","29","0.74"                 
"West","Kale","67","0.38"                  
"@                                         

$data | New-MiniPivot item region unitsold -Raw -Fill 0 | ft