# AC-Circuit-Solver-Updated

An automated AC Circuit solver, in which the input is given in the standard SPICE NETLIST format, and the output is the visual representation of the circuit on a zoomable svg, and the results (currents and volatges) in the output text file.

To make the resulting SVG zoomable, we have used an external git repository "svgpan.js", reference: https://github.com/ariutta/svg-pan-zoom

Due to the low precision in the value of PI, and the use of complex arithmetic in the <complex.h> header, some values may not be precise, assume an error of +=0.001 or so

All voltages and currents are measured with respect to a certain reference. We have assumed the ground (Net of name '0') to be at zero potential, provided it is mentioned in the netlist. If it is not mentioned in the netlist, then we have assumed the first net given in the netlist to be at potential '0'.

The phases might sometimes be opposite to what is expected. This is because for components (with nets say Net1 and Net2), it is ambigous whether we report voltages as potential of Net1 - potential of Net2 or potential of Net2 - potential of Net1, accordingly the phases will differ.

Thus, we have assumed that the phase difference is potential of <Net_Connected_to_terminal> - potential of <Net_Connected_to_other_terminal>, since current is assumed to flow from <Net_Connected_to_terminal> to <Net_Connected_to_other_terminal> and thus <Net_Connected_to_terminal> is at higher potential than the other (in our convention).

If phase does not match with expected result, please check whether our answer is 180 - (the expected phase). Because then it implies that we have considered the opposite potential difference of nets than what was expected
