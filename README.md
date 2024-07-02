# Iterated_FIR_Filter
Compare a direct implementation of a Narrow Bandwidth FIR Filter with a large Sample Rate to bandwidth ratio to an Iterated Design that implements the Narrowband Filter at a reduced sample rate and then interpolates up to the higher sample rate. The initial design is a FIR filter designed with a Kaiser Windowed Sinc filter. 

FIR_1: Single stage FIR Filter

FIR_4_to_1: The same filter response at the reduced sample rate of 50 kHz. The 4-to-1 sample rate reduction results in a filter of 1/4th the length. 

FIR_0_packed: Zero-pack the FIR_4_to_1 to form a double length filter (without any additional filter coefficients). This filter has a sample rate of 100 kHz. 

FIR_interpolated: Convolve the zero packed filter (FIR_0_packed) with the interpolating filter to form the new interpolated filter.

FIR_interpolated_0_packed: Now zero-pack the FIR_interpolated filter 1-to-2 to form a double length filter (without additional filter coefficients). This filter has a sample rate of 200 kHz. 

FIR_interpolated2_0_packed: Convolve the zero-packed filter with the interpolating filter to form the new interpolated filter. 

FIR_67: We now modify the problem to use the 67 tap filter to be zero packed 1-to-4 to form a quadruple length filter (without additional filter coefficients). This filter has a sample rate of 200 kHz.

FIR_67_interpolated3: Convolve the zero packed filter with the interpolating filter to form the new interpolated filter. 

