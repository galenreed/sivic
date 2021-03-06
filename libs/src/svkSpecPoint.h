/*
 *  Copyright © 2009-2017 The Regents of the University of California.
 *  All Rights Reserved.
 *
 *  Redistribution and use in source and binary forms, with or without 
 *  modification, are permitted provided that the following conditions are met:
 *  •   Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 *  •   Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 *  •   None of the names of any campus of the University of California, the name 
 *      "The Regents of the University of California," or the names of any of its 
 *      contributors may be used to endorse or promote products derived from this 
 *      software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 *  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 *  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 *  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
 *  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 *  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 *  OF SUCH DAMAGE.
 */



/*
 *  $URL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Authors:
 *      Jason C. Crane, Ph.D.
 *      Beck Olson
 */


#ifndef  SVK_SPEC_POINT_H           
#define  SVK_SPEC_POINT_H          


#include <vtkObjectFactory.h>
#include <svkDcmHeader.h>
#include <string>
#include <iostream>


namespace svk {


using namespace std;


class svkSpecPoint : public vtkObject
{

    public:

        static svkSpecPoint* New();
        vtkTypeMacro( svkSpecPoint, vtkObject);

        void    SetDcmHeader(svkDcmHeader* hdr);

        typedef enum {
            PPM = 0, 
            Hz,
            PTS 
        } UnitType;


        /*  
         *  frequency scale and ppm scale decrease from left to right.  
         *  frequency_offset is how far to the left in HZ (positive HZ), the water reference 
         *  was shifted.
         */
        float ConvertPosUnits(float position, int inType, int targetType); 
        //float ConvertPosUnits(float position, UnitType inType, UnitType targetType); 


    protected:

        svkSpecPoint();
        ~svkSpecPoint();


    private:

        float ConvertHzToPts(float positionHz, int numPts, float sweepWidth, float freqOffset); 
        float ConvertHzToPPM(float positionHz, float ppmRef, float freqOffset, float transmitFreq); 
        float ConvertPPMToHz(float positionPPM, float ppmRef, float freqOffset, float transmitFreq); 
        float ConvertPtsToHz(float positionPoints, int numPts, float sweepWidth, float freqOffset); 

        // member variables:
        float       sweepWidth;
        int         numPts;
        float       freqOffset;
        float       ppmRef;
        float       transmitFreq;

};

}

#endif //SVK_SPEC_POINT_H

