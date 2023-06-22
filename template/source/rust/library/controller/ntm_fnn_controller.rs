///////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _                  //
//                                           / _(_)    | |   | |                 //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |                 //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |                 //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |                 //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|                 //
//                  | |                                                          //
//                  |_|                                                          //
//                                                                               //
//                                                                               //
//              Peripheral-NTM for MPSoC                                         //
//              Neural Turing Machine for MPSoC                                  //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// Copyright (c) 2020-2024 by the author(s)                                      //
//                                                                               //
// Permission is hereby granted, free of charge, to any person obtaining a copy  //
// of this software and associated documentation files (the "Software"), to deal //
// in the Software without restriction, including without limitation the rights  //
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     //
// copies of the Software, and to permit persons to whom the Software is         //
// furnished to do so, subject to the following conditions:                      //
//                                                                               //
// The above copyright notice and this permission notice shall be included in    //
// all copies or substantial portions of the Software.                           //
//                                                                               //
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    //
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      //
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   //
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        //
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, //
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     //
// THE SOFTWARE.                                                                 //
//                                                                               //
// ============================================================================= //
// Author(s):                                                                    //
//   Paco Reina Campo <pacoreinacampo@queenfield.tech>                           //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////

pub struct ConvolutionalFnn {
    pub data_a_in: f64,
    pub data_b_in: f64,

    pub data_out: f64
}

pub struct StandardFnn {
    pub data_a_in: f64,
    pub data_b_in: f64,

    pub data_out: f64
}

impl ConvolutionalFnn {
    pub fn ntm_convolutional_fnn_controller(&self) -> f64 {
        // calculating addition
        return self.data_a_in + self.data_b_in
    }
}

impl StandardFnn {
    pub fn ntm_standard_fnn_controller(&self) -> f64 {
        // calculating addition
        return self.data_a_in + self.data_b_in
    }
}

#[allow(dead_code)]
fn main() {
    let convolutional_fnn = ConvolutionalFnn {
        data_a_in: 48.0,
        data_b_in: 16.0,

        data_out: 64.0
    };
    let standard_fnn = StandardFnn {
        data_a_in: 48.0,
        data_b_in: 16.0,

        data_out: 64.0
    };

    assert_eq!(convolutional_fnn.ntm_convolutional_fnn_controller(), convolutional_fnn.data_out);

    assert_eq!(standard_fnn.ntm_standard_fnn_controller(), standard_fnn.data_out);
}
