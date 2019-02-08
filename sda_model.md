The SDA Model v3.0
================
Geraldine Bürgel
30 Januar 2019

The aim of a structural decomposition analysis (SDA) is to break down the changes in the total output of an input-output model into its determinants.

### The basic model

The model is based on a standard Leontief input-output model where ![x = Ax + Y](https://latex.codecogs.com/png.latex?x%20%3D%20Ax%20%2B%20Y "x = Ax + Y") is solved by ![x = (I - A)^{-1}Y = LY](https://latex.codecogs.com/png.latex?x%20%3D%20%28I%20-%20A%29%5E%7B-1%7DY%20%3D%20LY "x = (I - A)^{-1}Y = LY").

![x](https://latex.codecogs.com/png.latex?x "x"): total output
![I](https://latex.codecogs.com/png.latex?I "I"): identity matrix
![A](https://latex.codecogs.com/png.latex?A "A"): matrix of technological coefficients
![Y](https://latex.codecogs.com/png.latex?Y "Y"): final demand
![L](https://latex.codecogs.com/png.latex?L "L"): Leontief inverse or matrix of total input requirements

We are working with FABIO (Bruckner, M., Maus, V., Wieland, H., Giljum, S., Moran, D., Wood, R., Többen, J., Börner, J. 2018), a multi-regional input-output (MRIO) database. The aim is to investigate sources of change in the land footprint of 191 countries and 130 different products worldwide. Therefore we introduce land use ![\\hat{u}](https://latex.codecogs.com/png.latex?%5Chat%7Bu%7D "\hat{u}") (the hat indicates a diagonalized matrix) into the Leontief model to get land footprint ![F](https://latex.codecogs.com/png.latex?F "F") as the outcome variable. Our basic model is

![F = \\hat{u}LY](https://latex.codecogs.com/png.latex?F%20%3D%20%5Chat%7Bu%7DLY "F = \hat{u}LY")

### Decomposition of L

Since the total input requirements are associated with technological change, we want to further unravel this variable for a more detailed analysis. In the following supplier countries are denoted by ![r = 1,...,m](https://latex.codecogs.com/png.latex?r%20%3D%201%2C...%2Cm "r = 1,...,m") with ![i = 1,...,n](https://latex.codecogs.com/png.latex?i%20%3D%201%2C...%2Cn "i = 1,...,n") intermediate products and producing countries are denoted by ![s = 1,...,m](https://latex.codecogs.com/png.latex?s%20%3D%201%2C...%2Cm "s = 1,...,m") with ![j = 1,...,n](https://latex.codecogs.com/png.latex?j%20%3D%201%2C...%2Cn "j = 1,...,n") final products. ![L](https://latex.codecogs.com/png.latex?L "L") gets decomposed into

![l^{pro} = \\frac{L^{rs}\_{ij}}{L^{rs}\_j}](https://latex.codecogs.com/png.latex?l%5E%7Bpro%7D%20%3D%20%5Cfrac%7BL%5E%7Brs%7D_%7Bij%7D%7D%7BL%5E%7Brs%7D_j%7D "l^{pro} = \frac{L^{rs}_{ij}}{L^{rs}_j}") representing the distribution of products produced.

![l^{sup} = \\frac{L^{rs}\_j}{L^s\_j}](https://latex.codecogs.com/png.latex?l%5E%7Bsup%7D%20%3D%20%5Cfrac%7BL%5E%7Brs%7D_j%7D%7BL%5Es_j%7D "l^{sup} = \frac{L^{rs}_j}{L^s_j}") representing the distribution of supplier countries of required inputs and

![l^{lev} = L^s\_j = \\sum\_{r=1}^{m}\\sum\_{i=1}^{n}L^{rs}\_{ij}](https://latex.codecogs.com/png.latex?l%5E%7Blev%7D%20%3D%20L%5Es_j%20%3D%20%5Csum_%7Br%3D1%7D%5E%7Bm%7D%5Csum_%7Bi%3D1%7D%5E%7Bn%7DL%5E%7Brs%7D_%7Bij%7D "l^{lev} = L^s_j = \sum_{r=1}^{m}\sum_{i=1}^{n}L^{rs}_{ij}") representing the level of total input requirements.

Thus ![L = l^{pro} l^{sup} l^{lev}](https://latex.codecogs.com/png.latex?L%20%3D%20l%5E%7Bpro%7D%20l%5E%7Bsup%7D%20l%5E%7Blev%7D "L = l^{pro} l^{sup} l^{lev}").

### Decomposition of Y

The final demand is being disassembled in a similar way, but with the addition of variables for GDP and population ![P](https://latex.codecogs.com/png.latex?P "P"). We are going to individually examine

![y^{pro} = \\frac{y^{rs}\_i}{y^{rs}}](https://latex.codecogs.com/png.latex?y%5E%7Bpro%7D%20%3D%20%5Cfrac%7By%5E%7Brs%7D_i%7D%7By%5E%7Brs%7D%7D "y^{pro} = \frac{y^{rs}_i}{y^{rs}}") displaying the distribution of products in the final demand and

![y^{sup} = \\frac{y^{rs}}{y^s}](https://latex.codecogs.com/png.latex?y%5E%7Bsup%7D%20%3D%20%5Cfrac%7By%5E%7Brs%7D%7D%7By%5Es%7D "y^{sup} = \frac{y^{rs}}{y^s}") showing the distribution of supplier countries of final demand,

![y^{lev} = \\frac{y^s}{GDP}](https://latex.codecogs.com/png.latex?y%5E%7Blev%7D%20%3D%20%5Cfrac%7By%5Es%7D%7BGDP%7D "y^{lev} = \frac{y^s}{GDP}") displaying the level of final demand per capita and

![G = \\frac{GDP}{P}](https://latex.codecogs.com/png.latex?G%20%3D%20%5Cfrac%7BGDP%7D%7BP%7D "G = \frac{GDP}{P}") for GDP per capita.

Finally we get ![Y = y^{pro} y^{sup} y^{lev} G P](https://latex.codecogs.com/png.latex?Y%20%3D%20y%5E%7Bpro%7D%20y%5E%7Bsup%7D%20y%5E%7Blev%7D%20G%20P "Y = y^{pro} y^{sup} y^{lev} G P").

The result is a decomposed model with nine determinants:

![F = \\hat{u}LY = \\hat{u} l^{pro} l^{sup} l^{lev} y^{pro} y^{sup} y^{lev} G P](https://latex.codecogs.com/png.latex?F%20%3D%20%5Chat%7Bu%7DLY%20%3D%20%5Chat%7Bu%7D%20l%5E%7Bpro%7D%20l%5E%7Bsup%7D%20l%5E%7Blev%7D%20y%5E%7Bpro%7D%20y%5E%7Bsup%7D%20y%5E%7Blev%7D%20G%20P "F = \hat{u}LY = \hat{u} l^{pro} l^{sup} l^{lev} y^{pro} y^{sup} y^{lev} G P").

The SDA
-------

There are two main approaches to conduct a structural decomposition analysis. According to Xu and Dietzenbacher (2014) there are ![k!](https://latex.codecogs.com/png.latex?k%21 "k!") equally valid alternative decomposition forms, ![k](https://latex.codecogs.com/png.latex?k "k") being the number of determinants. One method uses the average of all possible decompositions. The other method uses the average of the two polar decomposition forms, which is what I decided to do. The first polar form is derived by changing one variable after the other starting with the first one. The second polar form is achieved in a similar way, starting with the last variable. (Dietzenbacher and Los 1998)

The first polar decomposition form for two periods is deduced as follows:

![
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
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%5CDelta%20F%20%26%20%3D%20%28%5CDelta%5Chat%7Bu%7D%29l%5E%7Bpro%7D%281%29l%5E%7Bsup%7D%281%29l%5E%7Blev%7D%281%29y%5E%7Bpro%7D%281%29y%5E%7Bsup%7D%281%29y%5E%7Blev%7D%281%29G%281%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29%28%5CDelta%20l%5E%7Bpro%7D%29l%5E%7Bsup%7D%281%29l%5E%7Blev%7D%281%29y%5E%7Bpro%7D%281%29y%5E%7Bsup%7D%281%29y%5E%7Blev%7D%281%29G%281%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29l%5E%7Bpro%7D%281%29%28%5CDelta%20l%5E%7Bsup%7D%29l%5E%7Blev%7D%281%29y%5E%7Bpro%7D%281%29y%5E%7Bsup%7D%281%29y%5E%7Blev%7D%281%29G%281%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29l%5E%7Bpro%7D%280%29l%5E%7Bsup%7D%280%29%28%5CDelta%20l%5E%7Blev%7D%29y%5E%7Bpro%7D%281%29y%5E%7Bsup%7D%281%29y%5E%7Blev%7D%281%29G%281%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29l%5E%7Bpro%7D%280%29l%5E%7Bsup%7D%280%29l%5E%7Blev%7D%280%29%28%5CDelta%20y%5E%7Bpro%7D%29y%5E%7Bsup%7D%281%29y%5E%7Blev%7D%281%29G%281%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29l%5E%7Bpro%7D%280%29l%5E%7Bsup%7D%280%29l%5E%7Blev%7D%280%29y%5E%7Bpro%7D%280%29%28%5CDelta%20y%5E%7Bsup%7D%29y%5E%7Blev%7D%281%29G%281%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29l%5E%7Bpro%7D%280%29l%5E%7Bsup%7D%280%29l%5E%7Blev%7D%280%29y%5E%7Bpro%7D%280%29y%5E%7Bsup%7D%280%29%28%5CDelta%20y%5E%7Blev%7D%29G%281%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29l%5E%7Bpro%7D%280%29l%5E%7Bsup%7D%280%29l%5E%7Blev%7D%280%29y%5E%7Bpro%7D%280%29y%5E%7Bsup%7D%280%29y%5E%7Blev%7D%280%29%28%5CDelta%20G%29P%281%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%280%29l%5E%7Bpro%7D%280%29l%5E%7Bsup%7D%280%29l%5E%7Blev%7D%280%29y%5E%7Bpro%7D%280%29y%5E%7Bsup%7D%280%29y%5E%7Blev%7D%280%29G%280%29%28%5CDelta%20P%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
\Delta F & = (\Delta\hat{u})l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\
& + \hat{u}(0)(\Delta l^{pro})l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\
& + \hat{u}(0)l^{pro}(1)(\Delta l^{sup})l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\
& + \hat{u}(0)l^{pro}(0)l^{sup}(0)(\Delta l^{lev})y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)P(1)\\
& + \hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)(\Delta y^{pro})y^{sup}(1)y^{lev}(1)G(1)P(1)\\
& + \hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)(\Delta y^{sup})y^{lev}(1)G(1)P(1)\\
& + \hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)(\Delta y^{lev})G(1)P(1)\\
& + \hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)(\Delta G)P(1)\\
& + \hat{u}(0)l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)(\Delta P)
\end{aligned}
")

The second polar form can be derived in a similar way starting from the other end:

![
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
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%5CDelta%20F%20%20%26%20%3D%20%28%5CDelta%5Chat%7Bu%7D%29l%5E%7Bpro%7D%280%29l%5E%7Bsup%7D%280%29l%5E%7Blev%7D%280%29y%5E%7Bpro%7D%280%29y%5E%7Bsup%7D%280%29y%5E%7Blev%7D%280%29G%280%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29%28%5CDelta%20l%5E%7Bpro%7D%29l%5E%7Bsup%7D%280%29l%5E%7Blev%7D%280%29y%5E%7Bpro%7D%280%29y%5E%7Bsup%7D%280%29y%5E%7Blev%7D%280%29G%280%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29l%5E%7Bpro%7D%281%29%28%5CDelta%20l%5E%7Bsup%7D%29l%5E%7Blev%7D%280%29y%5E%7Bpro%7D%280%29y%5E%7Bsup%7D%280%29y%5E%7Blev%7D%280%29G%280%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29l%5E%7Bpro%7D%281%29l%5E%7Bsup%7D%281%29%28%5CDelta%20l%5E%7Blev%7D%29y%5E%7Bpro%7D%280%29y%5E%7Bsup%7D%280%29y%5E%7Blev%7D%280%29G%281%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29l%5E%7Bpro%7D%281%29l%5E%7Bsup%7D%281%29l%5E%7Blev%7D%281%29%28%5CDelta%20y%5E%7Bpro%7D%29y%5E%7Bsup%7D%280%29y%5E%7Blev%7D%280%29G%280%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29l%5E%7Bpro%7D%281%29l%5E%7Bsup%7D%281%29l%5E%7Blev%7D%281%29y%5E%7Bpro%7D%281%29%28%5CDelta%20y%5E%7Bsup%7D%29y%5E%7Blev%7D%280%29G%280%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29l%5E%7Bpro%7D%281%29l%5E%7Bsup%7D%281%29l%5E%7Blev%7D%281%29y%5E%7Bpro%7D%281%29y%5E%7Bsup%7D%281%29%28%5CDelta%20y%5E%7Blev%7D%29G%280%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29l%5E%7Bpro%7D%281%29l%5E%7Bsup%7D%281%29l%5E%7Blev%7D%281%29y%5E%7Bpro%7D%281%29y%5E%7Bsup%7D%281%29y%5E%7Blev%7D%281%29%28%5CDelta%20G%29P%280%29%5C%5C%0A%26%20%2B%20%5Chat%7Bu%7D%281%29l%5E%7Bpro%7D%281%29l%5E%7Bsup%7D%281%29l%5E%7Blev%7D%281%29y%5E%7Bpro%7D%281%29y%5E%7Bsup%7D%281%29y%5E%7Blev%7D%281%29G%281%29%28%5CDelta%20P%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
\Delta F  & = (\Delta\hat{u})l^{pro}(0)l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)P(0)\\
& + \hat{u}(1)(\Delta l^{pro})l^{sup}(0)l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)P(0)\\
& + \hat{u}(1)l^{pro}(1)(\Delta l^{sup})l^{lev}(0)y^{pro}(0)y^{sup}(0)y^{lev}(0)G(0)P(0)\\
& + \hat{u}(1)l^{pro}(1)l^{sup}(1)(\Delta l^{lev})y^{pro}(0)y^{sup}(0)y^{lev}(0)G(1)P(0)\\
& + \hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)(\Delta y^{pro})y^{sup}(0)y^{lev}(0)G(0)P(0)\\
& + \hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)(\Delta y^{sup})y^{lev}(0)G(0)P(0)\\
& + \hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)(\Delta y^{lev})G(0)P(0)\\
& + \hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)(\Delta G)P(0)\\
& + \hat{u}(1)l^{pro}(1)l^{sup}(1)l^{lev}(1)y^{pro}(1)y^{sup}(1)y^{lev}(1)G(1)(\Delta P)
\end{aligned}
")

For example, the first term on the right side of the equation therefore shows the impact on the total output if only the Leontief inverse changed and all other variables remained the same.

References
----------

Bruckner, M., Maus, V., Wieland, H., Giljum, S., Moran, D., Wood, R., Többen, J., Börner, J. 2018. “The Food and Agriculture Biomass Input-Output Database (Fabio): A Physical Supply-Use and Input-Output Dataset Covering Global Agriculture and Forestry.”

Dietzenbacher, Erik, and Bart Los. 1998. “Structural Decomposition Techniques: Sense and Sensitivity.” *Economic Systems Research* 10 (4): 307–24. doi:[10.1080/09535319800000023](https://doi.org/10.1080/09535319800000023).

Xu, Yan, and Erik Dietzenbacher. 2014. “A Structural Decomposition Analysis of the Emissions Embodied in Trade.” *Ecological Economics* 101: 10–20. doi:[10.1016/j.ecolecon.2014.02.015](https://doi.org/10.1016/j.ecolecon.2014.02.015).
