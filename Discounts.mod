set SITE := 1..10;		# number of mfg sites
set SUP := 1..15;		# number of suppliers

param d{j in SITE};		# demand of each sites, in tons
param s{i in SUP};		# supply of each supplier, in tons
param t{i in SUP, j in SITE};		# transportation cost to ship 1 ton from each supplier to each site

param c{i in SUP};		# base purchasing price of 1 ton
param q{i in SUP};		# shipping quanity required to reduce purchasing price, in tons
param a{i in SUP};		# fractional reduction in purchasing price each time param q requirement is acheived

var x{i in SUP, j in SITE} >= 0;		# total metric tons shipped from each supplier to each site
# var z{i in SUP, j in SITE} integer >= 0;		# the number of price discounts for each site from each supplier
var p{i in SUP} >= 0;       # Capacity Contraint Slack Variable
var v{i in SUP, j in SITE} >= 0;       # Discounts Constraint Slack Variable

# minimize AllUnitCost: sum{i in SUP, j in SITE}((t[i,j] * x[i,j]) + ((1 - (a[i] * z[i,j])) * c[i] * x[i,j]));
minimize AllUnitCost_relax: sum{i in SUP, j in SITE}((t[i,j] * x[i,j]) + ((1 - (a[i] * (x[i,j] / q[i]))) * c[i] * x[i,j]));
# minimize IncUnitCost: sum{i in SUP, j in SITE}(if x[i,j] = 0 then 0 else (t[i,j] * x[i,j]) + sum{k in 0..(z[i,j] - 1)}(c[i] * q[i] * v[i,j] * (1 - (a[i] * k))) + (c[i] * q[i] * v[i,j] * (1 - (a[i] * z[i,j]))));
s.t. Demand{j in SITE}: sum{i in SUP}(x[i,j]) = d[j];
s.t. Capacity{i in SUP}: sum{j in SITE}(x[i,j]) + p[i] = s[i];
# s.t. Discounts{i in SUP, j in SITE}: z[i,j] + v[i,j] = x[i,j] / q[i];



