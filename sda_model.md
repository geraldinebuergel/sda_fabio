The SDA Model v3.0
================
Geraldine Bürgel
30 Januar 2019

The aim of a structural decomposition analysis (SDA) is to break down the changes in the total output of an input-output model into its determinants.

### The basic model

The model is based on a standard Leontief input-output model where *x* = *A**x* + *Y* is solved by *x* = (*I* − *A*)<sup>−1</sup>*Y* = *L**Y*.

*x*: total output
*I*: identity matrix
*A*: matrix of technological coefficients
*Y*: final demand
*L*: Leontief inverse or matrix of total input requirements

We are working with FABIO (Bruckner, M., Maus, V., Wieland, H., Giljum, S., Moran, D., Wood, R., Többen, J., Börner, J. 2018), a multi regional input-output (MRIO) database. The aim is to investigate sources of change in the land footprint of 191 countries and 130 different products worldwide. Therefore we introduce land use $\\hat{u}$ (the hat indicates a diagonalised matrix) into the Leontief model to get land footprint *F* as the outcome variable. Our basic model is

$F = \\hat{u}LY$

### Decomposition of L

Since the total input requirements are associated with technological change, we want to further unravel this variable for a more detailed analysis. In the following supplier countries are denoted by *r* = 1, ..., *m* with *i* = 1, ..., *n* intermediate products and producing countries are denoted by *s* = 1, ..., *m* with *j* = 1, ..., *n* final products. *L* gets decomposed into

$l^{lev} = L^s\_j = \\sum\_{r=1}^{m}\\sum\_{i=1}^{n}L^{rs}\_{ij}$ representing the level of total input requirements,

$l^{sup} = \\frac{L^{rs}\_j}{L^s\_j}$ representing the distribution of supplier countries of required inputs,

$l^{pro} = \\frac{L^{rs}\_{ij}}{L^{rs}\_j}$ representing the distribution of products produced.

Consequently *L* = *l*<sup>*p**r**o*</sup>*l*<sup>*s**u**p*</sup>*l*<sup>*l**e**v*</sup>.

### Decomposition of Y

The final demand is being disassembled in a similar way, but with the addition of variables for GDP and population *P*. We are going to individually examine

$y^{lev} = \\frac{y^s}{GDP}$ displaying the level of final demand per capita,

$y^{sup} = \\frac{y^{rs}}{y^s}$ showing the distribution of supplier contries of final demand,

$y^{pro} = \\frac{y^{rs}\_i}{y^{rs}}$ displaying the distribution of products in the final demand and

$G = \\frac{GDP}{P}$ for GDP per capita.

Finally we get *Y* = *y*<sup>*p**r**o*</sup>*y*<sup>*s**u**p*</sup>*y*<sup>*l**e**v*</sup>*G**P*.

As a result we get the extended model with

$F = \\hat{u}LY = \\hat{u} l^{pro} l^{sup} l^{lev} y^{pro} y^{sup} y^{lev} G P$.

The SDA
-------

There are two main approaches to conduct a structural decomposition analysis. According to Xu and Dietzenbacher (2014) there are *k*! equally valid alternative decomposition forms, *k* being the number of determinants. One method uses the average of all possible decompositions. The other method uses the average of the two polar decomposition forms, which is what I decided to do. The first polar form is derived by changing one variable after the other starting with the first one. The second polar form is achieved in a similar way, starting with the last variable. (Dietzenbacher and Los 1998)

The first polar decomposition form for two periods is deduced as follows:

$$
\\begin{aligned}
\\Delta F & = (\\Delta\\hat{u})l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\\\
& + \\hat{u}(0)(\\Delta l^{pro})l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\\\
& + \\hat{u}(0)l^{pro}(1)(\\Delta l^{sup})l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\\\
& + \\hat{u}(0)l^{pro}(0)l^{sup}(0)(\\Delta l^{lev})y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\\\
& + \\hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)(\\Delta y^{pro})y^{sup}(1)y^{lev}(1)G(1)P(1)\\\\
& + \\hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)(\\Delta y^{sup})y^{lev}(1)G(1)P(1)\\\\
& + \\hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)(\\Delta y^{lev})G(1)P(1)\\\\
& + \\hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)(\\Delta G)P(1)\\\\
& + \\hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)(\\Delta P)
\\end{aligned}
$$

The second polar form can be derived in a similar way starting from the other end:

$$
\\begin{aligned}
\\Delta F  & = (\\Delta\\hat{u})l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)P(0)\\\\
& + \\hat{u}(1)(\\Delta l^{pro})l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)P(0)\\\\
& + \\hat{u}(1)l^{pro}(1)(\\Delta l^{sup})l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)P(0)\\\\
& + \\hat{u}(1)l^{pro}(1)l^{sup}(1)(\\Delta l^{lev})y^{pro}(0)y^{sup}(0)y^{lev}(0)G(1)P(0)\\\\
& + \\hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)(\\Delta y^{pro})y^{sup}(0)y^{lev}(0)G(0)P(0)\\\\
& + \\hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)(\\Delta y^{sup})y^{lev}(0)G(0)P(0)\\\\
& + \\hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)(\\Delta y^{lev})G(0)P(0)\\\\
& + \\hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)(\\Delta G)P(0)\\\\
& + \\hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)(\\Delta P)
\\end{aligned}
$$

For example, the first term on the right side of the equation therefore shows the impact on the total output if only the Leontief inverse changed and all other variables remained the same.

References
----------

Bruckner, M., Maus, V., Wieland, H., Giljum, S., Moran, D., Wood, R., Többen, J., Börner, J. 2018. “The Food and Agriculture Biomass Input-Output Database (Fabio): A Physical Supply-Use and Input-Output Dataset Covering Global Agriculture and Forestry.”

Dietzenbacher, Erik, and Bart Los. 1998. “Structural Decomposition Techniques: Sense and Sensitivity.” *Economic Systems Research* 10 (4): 307–24. doi:[10.1080/09535319800000023](https://doi.org/10.1080/09535319800000023).

Xu, Yan, and Erik Dietzenbacher. 2014. “A Structural Decomposition Analysis of the Emissions Embodied in Trade.” *Ecological Economics* 101: 10–20. doi:[10.1016/j.ecolecon.2014.02.015](https://doi.org/10.1016/j.ecolecon.2014.02.015).
