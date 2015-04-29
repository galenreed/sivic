/*
 *  Copyright © 2009-2014 The Regents of the University of California.
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
 *  $URL: svn+ssh://hawk-sf@svn.code.sf.net/p/sivic/code/trunk/libs/src/svkDCEWashout.h $
 *  $Rev: 2188 $
 *  $Author: jccrane $
 *  $Date: 2015-04-24 13:01:59 -0700 (Fri, 24 Apr 2015) $
 *
 *  Authors:
 *      Jason C. Crane, Ph.D.
 *      Beck Olson
 */


#ifndef SVK_DCE_PEAK_HEIGHT_H
#define SVK_DCE_PEAK_HEIGHT_H


#include <vtkObject.h>
#include <vtkObjectFactory.h>
#include <vtkInformation.h>

#include <svkImageData.h>
#include <svkMriImageData.h>
#include <svkImageAlgorithm.h>
#include <svkDcmHeader.h>
#include <svkDynamicImageMap.h>


namespace svk {


using namespace std;


/*! 
 *  Class to derive peak height from a DCE image 
 */
class svkDCEWashout: public svkDynamicImageMap
{

    public:

        static svkDCEWashout *New();
        vtkTypeRevisionMacro( svkDCEWashout, svkDynamicImageMap);


    protected:

        svkDCEWashout();
        ~svkDCEWashout();


    private:

        //  Methods:
        virtual void            GenerateMap(); 
        double                  GetMapVoxelValue( float* dynamicVoxelPtr ); 
        double                  GetWashout( float* dynamicVoxelPtr, int injectionPoint, float imageRate, int numberSlices );
        double                  GetBaselineArray( float* data );
        int                     GetInjectionPoint( float* baselineArray );
};


}   //svk


#endif //SVK_DCE_PEAK_HEIGHT_H
