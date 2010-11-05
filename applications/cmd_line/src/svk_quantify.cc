/*
 *  Copyright © 2009-2010 The Regents of the University of California.
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
 *  $URL: https://sivic.svn.sourceforge.net/svnroot/sivic/trunk/applications/cmd_line/src/svk_quantify.cc $
 *  $Rev: 427 $
 *  $Author: jccrane $
 *  $Date: 2010-07-29 16:30:45 -0700 (Thu, 29 Jul 2010) $
 *
 *  Authors:
 *      Jason C. Crane, Ph.D.
 *      Beck Olson
 *
 *  License: TBD
 *
 *  Utility application for converting between supported file formats. 
 *
 */


#include <vtkSmartPointer.h>

#include <svkImageReaderFactory.h>
#include <svkImageReader2.h>
#include <svkImageWriterFactory.h>
#include <svkImageWriter.h>
#include <svkIntegratePeak.h>
#include <svkExtractMRIFromMRS.h>

#include <getopt.h>

#define UNDEFINED_VAL -99999


using namespace svk;


int main (int argc, char** argv)
{

    string usemsg("\n") ; 
    usemsg += "Version " + string(SVK_RELEASE_VERSION) + "\n";   
    usemsg += "svk_quantify -i input_file_name -o output_file_name -t output_data_type [-h] \n";
    usemsg += "\n";  
    usemsg += "   -i input_file_name        name of file to convert. \n"; 
    usemsg += "   -o output_file_name       name of outputfile. \n";  
    usemsg += "   -t output_data_type       target data type: \n";  
    usemsg += "                                 3 = UCSF IDF      \n";  
    usemsg += "                                 6 = DICOM_MRI     \n";  
    usemsg += "   --peak_center       ppm   Chemical shift of peak center \n";
    usemsg += "   --peak_width        ppm   Width in ppm of peak integration \n";
    usemsg += "   --peak_name         name  String label name for peak \n"; 
    usemsg += "   -h                        print help mesage. \n";  
    usemsg += " \n";  
    usemsg += "Generates metabolite map volume by direct integration of input spectra over the specified chemical shift range. \n";
    usemsg += "\n";  

    string inputFileName; 
    string outputFileName; 
    svkImageWriterFactory::WriterType dataTypeOut = svkImageWriterFactory::UNDEFINED; 
    float peak_center_ppm;
    float peak_width_ppm;
    string peak_name;

    string cmdLine = svkProvenance::GetCommandLineString( argc, argv );

    enum FLAG_NAME {
        FLAG_PEAK_CENTER = 0,
        FLAG_PEAK_WIDTH, 
        FLAG_PEAK_NAME
    };


    static struct option long_options[] =
    {
        /* This option sets a flag. */
        {"peak_center",      required_argument, NULL,  FLAG_PEAK_CENTER},
        {"peak_width",       required_argument, NULL,  FLAG_PEAK_WIDTH},
        {"peak_name",        required_argument, NULL,  FLAG_PEAK_NAME},
        {0, 0, 0, 0}
    };


    // ===============================================
    //  Process flags and arguments
    // ===============================================
    int i;
    int option_index = 0;
    while ( ( i = getopt_long(argc, argv, "i:o:t:h", long_options, &option_index) ) != EOF) {
        switch (i) {
            case 'i':
                inputFileName.assign( optarg );
                break;
            case 'o':
                outputFileName.assign(optarg);
                break;
            case 't':
                dataTypeOut = static_cast<svkImageWriterFactory::WriterType>( atoi(optarg) );
                break;
           case FLAG_PEAK_CENTER:
                peak_center_ppm = atof( optarg);
                break;
           case FLAG_PEAK_WIDTH:
                peak_width_ppm = atof( optarg);
                break;
           case FLAG_PEAK_NAME:
                peak_name.assign( optarg);
                break;
            case 'h':
                cout << usemsg << endl;
                exit(1);  
                break;
            default:
                ;
        }
    }

    argc -= optind;
    argv += optind;
    cout << inputFileName << endl;
    cout << outputFileName << endl;
    cout << dataTypeOut << endl;
    cout << peak_center_ppm << endl;
    cout << peak_width_ppm << endl;
    cout << peak_name<< endl;

    if ( argc != 0 ||  inputFileName.length() == 0 || outputFileName.length() == 0 ||
        dataTypeOut < 0 || dataTypeOut >= svkImageWriterFactory::LAST_TYPE || 
        peak_center_ppm == UNDEFINED_VAL || peak_width_ppm == UNDEFINED_VAL || peak_name.length() == 0 ) {
        cout << usemsg << endl;
        exit(1); 
    }

    cout << inputFileName << endl;
    cout << outputFileName << endl;
    cout << dataTypeOut << endl;
    cout << peak_center_ppm << endl;
    cout << peak_width_ppm << endl;
    cout << peak_name<< endl;


    // ===============================================
    //  Use a reader factory to get the correct reader
    //  type .
    // ===============================================
    vtkSmartPointer< svkImageReaderFactory > readerFactory = vtkSmartPointer< svkImageReaderFactory >::New();
    svkImageReader2* reader = readerFactory->CreateImageReader2(inputFileName.c_str());

    if (reader == NULL) {
        cerr << "Can not determine appropriate reader for: " << inputFileName << endl;
        exit(1);
    }


    // ===============================================
    //  Use the reader to read the data into an
    //  svkMrsImageData object and set any reading
    //  behaviors (e.g. average suppressed data).
    // ===============================================
    reader->SetFileName( inputFileName.c_str() );
    reader->Update(); 

    vtkImageData* tmpImage = vtkImageData::New(); 

    svkExtractMRIFromMRS* quant = svkExtractMRIFromMRS::New();
    quant->SetInput( reader->GetOutput() ); 
    quant->Delete();

    // ===============================================  
    //  Write the data out to the specified file type.  
    //  Use an svkImageWriterFactory to obtain the
    //  correct writer type. 
    // ===============================================  
    vtkSmartPointer< svkImageWriterFactory > writerFactory = vtkSmartPointer< svkImageWriterFactory >::New(); 
    svkImageWriter* writer = static_cast<svkImageWriter*>( writerFactory->CreateImageWriter( dataTypeOut ) ); 
    
    if ( writer == NULL ) {
        cerr << "Can not determine writer of type: " << dataTypeOut << endl;
        exit(1);
    }
   
    writer->SetFileName( outputFileName.c_str() );
    writer->SetInput( quant->GetOutput() );

    //  Set the input command line into the data set provenance:
    reader->GetOutput()->GetProvenance()->SetApplicationCommand( cmdLine );

    writer->Write();

    writer->Delete();
    reader->Delete();

    return 0; 
}



