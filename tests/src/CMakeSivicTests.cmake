# 
#   Copyright © 2009-2014 The Regents of the University of California.
#   All Rights Reserved.
# 
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#   •   Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#   •   Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#   •   None of the names of any campus of the University of California, the name
#       "The Regents of the University of California," or the names of any of its
#       contributors may be used to endorse or promote products derived from this
#       software without specific prior written permission.
# 
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#   IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
#   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
#   OF SUCH DAMAGE.
#

#
#   $URL$
#   $Rev$
#   $Author$
#   $Date$
#
#   Authors:
#       Jason C. Crane, Ph.D.
#       Beck Olson

# For now we will use the linux test results for comparison on all platforms
SET( DEFAULT_TEST_PLATFORM Linux_x86_64 )

#############################################################
#   Paths to binary applications and scripts
#############################################################
SET( TEST_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/trunk/tests/scripts)
IF(WIN32)
	SET( TEST_BIN_PATH_CMD_LINE ${CMAKE_BINARY_DIR}/trunk/applications/cmd_line/src/${PLATFORM})
    SET( DIFF_COMMAND ${GNU_DIFFUTILS_PATH}/bin/diff.exe )
    SET( TEST_PLATFORM Win32 )
ELSE(WIN32)
    SET( TEST_BIN_PATH_CMD_LINE ${CMAKE_BINARY_DIR}/trunk/applications/cmd_line/${PLATFORM})
    SET( DIFF_COMMAND diff )
    SET( TEST_PLATFORM ${PLATFORM} )
ENDIF(WIN32)

SET( DCM_2_XML_COMMAND ${DCMTK_DIR}/bin/dcm2xml )
SET( TEST_BIN_PATH_TESTS ${CMAKE_BINARY_DIR}/trunk/tests/${PLATFORM})

#############################################################
#   Location where output files from individual tests 
#   are written to. 
#############################################################
SET( TEST_RESULTS_ROOT ${SVK_TEST_ROOT}/results_tmp)
file( MAKE_DIRECTORY ${TEST_RESULTS_ROOT} )

#############################################################
#   Flags for diff to avoid errors from minor differences in 
#   paths and rootnames in header files and provenance. 
#############################################################
IF(WIN32)
    # Windows prints expenontial incorrectly so we have to ignore the max/min values for now.
    SET( DIFF_OPT --ignore-matching-lines=SVK_ --ignore-matching-lines=root --ignore-matching-lines=minimum: --exclude=.svn)
ELSE(WIN32)
    SET( DIFF_OPT --ignore-matching-lines=SVK_ --ignore-matching-lines=root --exclude=.svn)
ENDIF(WIN32)
SET( DIFF_OPT_DCM --ignore-matching-lines=UID --ignore-matching-lines="0002,0000" --ignore-matching-lines="0002,0012" --ignore-matching-lines="0002,0013" --ignore-matching-lines="0008,0000" --ignore-matching-lines="0020,0000" --exclude=.svn )
STRING(REPLACE ";" " " DIFF_OPT_DCM_STR "${DIFF_OPT_DCM}")

########################
#   
########################
SET( TEST_NAME INSTANTIATION_TEST_MCHK)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkInstantiationTest )

#############################################################
#   Tests are in pairs:
#     - odd tests are calls to svk binaries which can be tested with valgrind
#       for memory checking (dynamic ctest analysis).  Files are generated from  
#       these tests into $(TEST_RESULTS_ROOT).  Even tests check for run-time errors
#       and memory allocation. 
#     - even tests diff result files generated in the odd test against a baseline 
#       file.  Even test check for processing correctness. 
#############################################################

########################
#   24X GE Raw to DDF
########################
#SET( TEST_NAME TEST_MCHK_24XPF_2_DDF)
#SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
#file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
#SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/24x)
#ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/24x -o${TEST_RESULTS_PATH}/out -t 2 )
#
#SET( TEST_NAME TEST_24XPF_2_DDF_DIFF)
#ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/output )
#SET_TESTS_PROPERTIES(TEST_24XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_24XPF_2_DDF)

########################
#   23X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_23XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/23x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/23x -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_23XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/output )
SET_TESTS_PROPERTIES(TEST_23XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_23XPF_2_DDF)

########################
#   20X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_20XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/20x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/20_x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_20XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_20XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_20XPF_2_DDF)

########################
#   15X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_15XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/15x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/15x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_15XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_15XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_15XPF_2_DDF)


########################
#   14X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_14XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/14x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_14XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_14XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_14XPF_2_DDF)


########################
#   12X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_12XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/12x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/12x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_12XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_12XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_12XPF_2_DDF)


########################
#   11X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_11XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/11x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/11x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_11XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_11XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_11XPF_2_DDF)

##################################################################
#   9X GE Raw With Swap to DDF
#
#   NOTE: The input for this test was modified so that rhr.rh_user7 
#         rhr.rh_user8, and rhr.rh_user9 values match the FOV.
#         This test passing does not show that 9x reading is
#         correct for GE Data, but just that the swap logic is
#         returning the expected result.
#
########################
SET( TEST_NAME TEST_MCHK_9XPF_SWAP_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/9x_swap)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/axge_ap -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_9XPF_SWAP_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_9XPF_SWAP_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_9XPF_SWAP_DDF)

########################
#   UCSF ddf to UCSF DDF
########################
SET( TEST_NAME TEST_MCHK_DDF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ddf_files/ddf_to_ddf)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/20x_1.ddf -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_DDF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_DDF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_DDF_2_DDF)


########################
#   DICOM MRI to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_DCMMRI_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/DICOM/mri_phantom)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E0000S4I1.DCM -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_DCMMRI_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_1 )
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_DCMMRI_2_IDF)


########################
#   DICOM MRI to DICOM MRI 
########################
SET( TEST_NAME TEST_MCHK_DCMMRI_2_DCMMRI)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/DICOM/mri_phantom)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E0000S4I1.DCM -o${TEST_RESULTS_PATH}/out.dcm -t 6 )

SET( TEST_NAME TEST_DCMMRI_2_DCMMRI_XML)
ADD_TEST(${TEST_NAME} ${DCM_2_XML_COMMAND} +M +Wb ${TEST_RESULTS_PATH}/out.dcm ${TEST_RESULTS_PATH}/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_DCMMRI_XML PROPERTIES DEPENDS TEST_MCHK_DCMMRI_2_DCMMRI)
   
SET( TEST_NAME TEST_DCMMRI_2_DCMMRI_DIFF)
ADD_TEST(${TEST_NAME} ${DIFF_COMMAND} ${DIFF_OPT_DCM} -r ${TEST_RESULTS_PATH}/out.xml ${TEST_CASE_ROOT}/out_2/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_DCMMRI_DIFF PROPERTIES DEPENDS TEST_DCMMRI_2_DCMMRI_XML)


########################
#   DEID DICOM MRI to DICOM MRI 
########################
SET( TEST_NAME TEST_MCHK_DCMMRI_2_DCMMRI_ANON)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/DICOM/mri_phantom)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert --deid_type 2 --deid_id ANONYMIZED -i ${TEST_CASE_ROOT}/input/E0000S4I1.DCM -o${TEST_RESULTS_PATH}/out.dcm -t 6 )

SET( TEST_NAME TEST_DCMMRI_2_DCMMRI_ANON_XML)
ADD_TEST(${TEST_NAME} ${DCM_2_XML_COMMAND} +M +Wb ${TEST_RESULTS_PATH}/out.dcm ${TEST_RESULTS_PATH}/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_DCMMRI_ANON_XML PROPERTIES DEPENDS TEST_MCHK_DCMMRI_2_DCMMRI_ANON)
   
SET( TEST_NAME TEST_DCMMRI_2_DCMMRI_ANON_DIFF)
ADD_TEST(${TEST_NAME} ${DIFF_COMMAND} ${DIFF_OPT_DCM} -r ${TEST_RESULTS_PATH}/out.xml ${TEST_CASE_ROOT}/out_3/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_DCMMRI_ANON_DIFF PROPERTIES DEPENDS TEST_DCMMRI_2_DCMMRI_ANON_XML)

########################
#   UCSF IDF to UCSF IDF 
#   int2
########################
SET( TEST_NAME TEST_MCHK_IDF_2_IDF_INT2)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/idf_files/idf_to_idf_int2)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/vol.idf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_IDF_2_IDF_INT2_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_IDF_2_IDF_INT2_DIFF PROPERTIES DEPENDS TEST_MCHK_IDF_2_IDF_INT2)


########################
#   UCSF IDF to UCSF IDF 
#   real 
########################
SET( TEST_NAME TEST_MCHK_IDF_2_IDF_REAL)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/idf_files/idf_to_idf_real)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/vol.idf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_IDF_2_IDF_REAL_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_IDF_2_IDF_REAL_DIFF PROPERTIES DEPENDS TEST_MCHK_IDF_2_IDF_REAL)


########################
#   VARIAN fdf to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_FDF_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/varian/fdf)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/lac.0001.fdf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_FDF_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_FDF_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_FDF_2_IDF)


########################
#   VARIAN fid to UCSF DDF 
########################
SET( TEST_NAME TEST_MCHK_VARIANFID_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/varian/fid_cs)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/fid -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_VARIANFID_2_DDF_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_VARIANFID_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_VARIANFID_2_DDF)


########################
#   GE Signa 5x to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_SIGNA5X_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_signa_files/Signa5x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E8668S3I1.MR -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_SIGNA5X_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_SIGNA5X_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_SIGNA5X_2_IDF)


########################
#   GE Signa 5x V2 to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_SIG5XV2_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_signa_files/Signa5XVersion2)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E18636S3I1.MR -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_SIG5XV2_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_SIG5XV2_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_SIG5XV2_2_IDF)



########################
#   GE Signa LX2 to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_SIGLX2_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_signa_files/SignaLX2)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E12916S3I1.MR -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_SIGLX2_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_SIGLX2_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_SIGLX2_2_IDF)


########################
#   SIEMENS RDA to DDF
########################
SET( TEST_NAME TEST_MCHK_RDA_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/siemens_rda/sv)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/sample.rda -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_RDA_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM} )
SET_TESTS_PROPERTIES(TEST_RDA_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_RDA_2_DDF)


########################
#   DICOM MRS to DICOM MRS 
#   only checks the header
########################
SET( TEST_NAME TEST_MCHK_DCMMRS_2_DCMMRS)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/DICOM/mrs)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/mrs.dcm -o${TEST_RESULTS_PATH}/out.dcm -t 4 )

SET( TEST_NAME TEST_DCMMRS_2_DCMMRS_XML)
ADD_TEST(${TEST_NAME} ${DCM_2_XML_COMMAND} +M +Wb ${TEST_RESULTS_PATH}/out.dcm ${TEST_RESULTS_PATH}/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRS_2_DCMMRS_XML PROPERTIES DEPENDS TEST_MCHK_DCMMRS_2_DCMMRS)

SET( TEST_NAME TEST_DCMMRS_2_DCMMRS_DIFF )
ADD_TEST(${TEST_NAME} ${DIFF_COMMAND} ${DIFF_OPT_DCM} -r ${TEST_RESULTS_PATH}/out.xml ${TEST_CASE_ROOT}/${DEFAULT_TEST_PLATFORM}/out.xml)
SET_TESTS_PROPERTIES(TEST_DCMMRS_2_DCMMRS_DIFF PROPERTIES DEPENDS TEST_DCMMRS_2_DCMMRS_XML)


########################
#   PFile Reader Tests: 
########################
SET( TEST_NAME TEST_MCHK_GEPFILE_2_DDF_1)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME}/ )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x_mbrease)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/mbrease_teavg -o${TEST_RESULTS_PATH}/out -t 2 -as )

SET( TEST_NAME TEST_GEPFILE_2_DDF_1_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_4 )
SET_TESTS_PROPERTIES(TEST_GEPFILE_2_DDF_1_DIFF PROPERTIES DEPENDS TEST_MCHK_GEPFILE_2_DDF_1)


########################
#   PFile Reader Tests: 
#   this one is too large for valgrind 
#   so turn off MCHK for now:
########################
SET( TEST_NAME TEST_MCHK_GEPFILE_2_DDF_2)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x_mbrease)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/mbrease_teavg -o${TEST_RESULTS_PATH}/out -t 2 -a -u )

SET( TEST_NAME TEST_GEPFILE_2_DDF_2_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_6 )
SET_TESTS_PROPERTIES(TEST_GEPFILE_2_DDF_2_DIFF PROPERTIES DEPENDS TEST_MCHK_GEPFILE_2_DDF_2)


########################
#   PFile Reader Tests: 
#   this one is too large for valgrind 
#   so turn off MCHK for now:
########################
SET( TEST_NAME TEST_MCHK_GEPFILE_2_DDF_LAC)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x_lac_flyback)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/14x_lac_flyback -o${TEST_RESULTS_PATH}/out -t 2  --one_time_pt)

SET( TEST_NAME TEST_GEPFILE_2_DDF_LAC_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_GEPFILE_2_DDF_LAC_DIFF PROPERTIES DEPENDS TEST_MCHK_GEPFILE_2_DDF_LAC)


########################
#   PFile Anon Tests: 
#   this runs inplace, so make a copy of the input file first
########################
SET( TEST_NAME TEST_MCHK_GEPFILE_ANON )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/20x)
file( COPY ${TEST_CASE_ROOT}/input/20_x_raw DESTINATION ${TEST_RESULTS_PATH})
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_anon -i ${TEST_RESULTS_PATH}/20_x_raw --deid_id TEST_ANON_ID --study_uid 1.2.3.4 --series_uid 5.6.7.8 )

SET( TEST_NAME TEST_GEPFILE_ANON_CONVERT)
ADD_TEST(${TEST_NAME} ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_RESULTS_PATH}/20_x_raw -o ${TEST_RESULTS_PATH}/20_x_raw.dcm -t4  ) 
SET_TESTS_PROPERTIES(TEST_GEPFILE_ANON_CONVERT PROPERTIES DEPENDS TEST_MCHK_GEPFILE_ANON)

SET( TEST_NAME TEST_GEPFILE_ANON_XML)
ADD_TEST(${TEST_NAME} ${DCM_2_XML_COMMAND} +M +Wb ${TEST_RESULTS_PATH}/20_x_raw.dcm ${TEST_RESULTS_PATH}/20_x_raw.xml ) 
SET_TESTS_PROPERTIES(TEST_GEPFILE_ANON_XML PROPERTIES DEPENDS TEST_GEPFILE_ANON_CONVERT)

SET( TEST_NAME TEST_GEPFILE_ANON_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT_DCM} -r ${TEST_RESULTS_PATH}/20_x_raw.xml ${TEST_CASE_ROOT}/anon_out/20_x_raw.xml )
SET_TESTS_PROPERTIES(TEST_GEPFILE_ANON_DIFF PROPERTIES DEPENDS TEST_GEPFILE_ANON_XML)


########################
#   Oblique Reslice: 
########################
SET( TEST_NAME TEST_MCHK_OBLIQUE_RESLICE)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/reslicing/axial_to_oblique)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_reslice -i ${TEST_CASE_ROOT}/input/axial_vol.idf --target ${TEST_CASE_ROOT}/input/oblique_mrsvol.ddf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_OBLIQUE_RESLICE_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/out )
SET_TESTS_PROPERTIES(TEST_OBLIQUE_RESLICE_DIFF PROPERTIES DEPENDS TEST_MCHK_OBLIQUE_RESLICE)


########################
#   Metabolite Map Generation
########################
SET( TEST_NAME TEST_MCHK_INTEGRATE_MET_MAP)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/met_maps/integration_pk_ht)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_quantify -i ${TEST_CASE_ROOT}/input/mrs.ddf -o${TEST_RESULTS_PATH}/out -t 3 --peak_center 1.99 --peak_width .4 --peak_name NAA --algo 2)

SET( TEST_NAME TEST_INTEGRATE_MET_MAP_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_INTEGRATE_MET_MAP_DIFF PROPERTIES DEPENDS TEST_MCHK_INTEGRATE_MET_MAP)


########################
#   Metabolite Map Generation
########################
SET( TEST_NAME TEST_MCHK_MAG_INTEGRATE_MET_MAP)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/met_maps/integration_pk_ht)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_quantify -i ${TEST_CASE_ROOT}/input/mrs.ddf -o${TEST_RESULTS_PATH}/out -t 6 --peak_center 1.99 --peak_width .4 --peak_name NAA --algo 5)

SET( TEST_NAME TEST_MAG_INTEGRATE_MET_MAP_DIFF)
ADD_TEST(${TEST_NAME} perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND}  -v  --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/out_2 --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_MAG_INTEGRATE_MET_MAP_DIFF PROPERTIES DEPENDS TEST_MCHK_MAG_INTEGRATE_MET_MAP)

########################
#   Metabolite Map Generation
########################
SET( TEST_NAME TEST_MCHK_PEAK_HT_MET_MAP)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/met_maps/integration_pk_ht)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_quantify -i ${TEST_CASE_ROOT}/input/mrs.ddf -o${TEST_RESULTS_PATH}/out -t 6 --peak_center 1.99 --peak_width .4 --peak_name NAA --algo 1)

SET( TEST_NAME TEST_PEAK_HT_MET_MAP_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/out_3 --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_PEAK_HT_MET_MAP_DIFF PROPERTIES DEPENDS TEST_MCHK_PEAK_HT_MET_MAP)


########################
#   Metabolite Map Generation
########################
SET( TEST_NAME TEST_MCHK_MAG_PEAK_HT_MET_MAP)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/met_maps/integration_pk_ht)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_quantify -i ${TEST_CASE_ROOT}/input/mrs.ddf -o${TEST_RESULTS_PATH}/out -t 6 --peak_center 1.99 --peak_width .4 --peak_name NAA --algo 4)

SET( TEST_NAME TEST_MAG_PEAK_HT_MET_MAP_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/out_4 --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_MAG_PEAK_HT_MET_MAP_DIFF PROPERTIES DEPENDS TEST_MCHK_MAG_PEAK_HT_MET_MAP)


########################
#   Metabolite Map Generation
########################
SET( TEST_NAME TEST_MCHK_LINE_WIDTH_MET_MAP)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/met_maps/integration_pk_ht)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_quantify -i ${TEST_CASE_ROOT}/input/mrs.ddf -o${TEST_RESULTS_PATH}/out -t 6 --peak_center 1.99 --peak_width .4 --peak_name NAA --algo 3)

SET( TEST_NAME TEST_LINE_WIDTH_MET_MAP_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/out_5 --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_LINE_WIDTH_MET_MAP_DIFF PROPERTIES DEPENDS TEST_MCHK_LINE_WIDTH_MET_MAP)


########################
#   Metabolite Map Generation
########################
SET( TEST_NAME TEST_MCHK_MAG_LINE_WIDTH_MET_MAP)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/met_maps/integration_pk_ht)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_quantify -i ${TEST_CASE_ROOT}/input/mrs.ddf -o${TEST_RESULTS_PATH}/out -t 6 --peak_center 1.99 --peak_width .4 --peak_name NAA --algo 6)

SET( TEST_NAME TEST_MAG_LINE_WIDTH_MET_MAP_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/out_6 --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_MAG_LINE_WIDTH_MET_MAP_DIFF PROPERTIES DEPENDS TEST_MCHK_MAG_LINE_WIDTH_MET_MAP)

########################
#   MRS FFT test: 
########################
SET( TEST_NAME TEST_MCHK_MRS_FFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_fft)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsImageFFT ${TEST_CASE_ROOT}/input/raw.ddf ${TEST_RESULTS_PATH}/recon )

SET( TEST_NAME TEST_MRS_FFT_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_MRS_FFT_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_FFT)

########################
#   MRI FFT test: 
########################
SET( TEST_NAME TEST_MCHK_EVEN_MRI_FFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mri_fft)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriImageFFTTest ${TEST_CASE_ROOT}/input/testBoxEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_MRI_FFT_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_MRI_FFT_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_MRI_FFT)

########################
#   MRI FFT test: 
########################
SET( TEST_NAME TEST_MCHK_ODD_MRI_FFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mri_fft)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriImageFFTTest ${TEST_CASE_ROOT}/input/testBoxOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_MRI_FFT_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_MRI_FFT_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_MRI_FFT)

####################################################
#   Image center test for even image dimensions
####################################################
SET( TEST_NAME TEST_MCHK_EVEN_IMAGE_CENTER )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_center)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageFourierCenterTest ${TEST_CASE_ROOT}/input/constantEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_IMAGE_CENTER_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_IMAGE_CENTER_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_IMAGE_CENTER)

####################################################
#   Image center test for odd image dimensions
####################################################
SET( TEST_NAME TEST_MCHK_ODD_IMAGE_CENTER )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_center)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageFourierCenterTest ${TEST_CASE_ROOT}/input/constantOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_IMAGE_CENTER_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_IMAGE_CENTER_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_IMAGE_CENTER)

########################
#   Image padding test: 
########################
SET( TEST_NAME TEST_MCHK_EVEN_IMAGE_PAD )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_pad)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriZeroFillTest ${TEST_CASE_ROOT}/input/testBoxCenterEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_IMAGE_PAD_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_IMAGE_PAD_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_IMAGE_PAD)

########################
#   Image padding test: 
########################
SET( TEST_NAME TEST_MCHK_ODD_IMAGE_PAD )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_pad)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriZeroFillTest ${TEST_CASE_ROOT}/input/testBoxCenterOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_IMAGE_PAD_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_IMAGE_PAD_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_IMAGE_PAD)

########################
#   Spectra padding test: 
########################
SET( TEST_NAME TEST_MCHK_MRS_ZERO_FILL )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_zero_fill)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsZeroFillTest ${SVK_TEST_ROOT}/mrs_zero_fill/input/delta.ddf ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_MRS_ZERO_FILL_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_MRS_ZERO_FILL_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_ZERO_FILL)

########################
#   voxel shifting: 
########################
SET( TEST_NAME TEST_MCHK_MRS_VOXEL_SHIFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_voxel_shift)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsFFTVoxelShiftTest ${SVK_TEST_ROOT}/mrs_zero_fill/input/delta.ddf ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_MRS_VOXEL_SHIFT_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_MRS_VOXEL_SHIFT_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_VOXEL_SHIFT)


SET( TEST_NAME TEST_MRS_FFT_VOXEL_SHIFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_fft)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_fft -i ${TEST_CASE_ROOT}/input_2/svstest_1.ddf -o ${TEST_RESULTS_PATH}/out -t 2 --vsx .5 --vsy .5 )

SET( TEST_NAME TEST_MRS_FFT_VOXEL_SHIFT_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_2 )
SET_TESTS_PROPERTIES( TEST_MRS_FFT_VOXEL_SHIFT_DIFF PROPERTIES DEPENDS TEST_MRS_FFT_VOXEL_SHIFT )

########################
#   Spectra phase test: 
########################
SET( TEST_NAME TEST_PHASE_SPEC )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/phase_spec)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsLinearPhaseTest ${SVK_TEST_ROOT}/mrs_zero_fill/input/delta.ddf ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_PHASE_SPEC_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_PHASE_SPEC_DIFF PROPERTIES DEPENDS TEST_PHASE_SPEC )

##################################################################
#   Spectra zero and linear phase test in the spectral domain. 
##################################################################
SET( TEST_NAME TEST_MCHK_PHASE_ZERO_LINEAR_SPEC )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/phase_zero_linear_spec)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_phase_spec -i ${SVK_TEST_ROOT}/mrs_fft/out/recon.ddf -o ${TEST_RESULTS_PATH}/out -z 77 -l -227 -p 117 -t 2 )

SET( TEST_NAME TEST_PHASE_ZERO_LINEAR_SPEC_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/out )
SET_TESTS_PROPERTIES(TEST_PHASE_ZERO_LINEAR_SPEC_DIFF PROPERTIES DEPENDS TEST_MCHK_PHASE_ZERO_LINEAR_SPEC )

##################################################################
#   Spectra zero and linear phase test in the spectral domain. 
##################################################################
SET( TEST_NAME TEST_MCHK_PHASE_ZERO_LINEAR_SPEC_2 )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/phase_zero_linear_spec)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkZeroLinearPhaseTest -i ${SVK_TEST_ROOT}/mrs_fft/out/recon.ddf -o ${TEST_RESULTS_PATH}/phase_changes )

SET( TEST_NAME TEST_PHASE_ZERO_LINEAR_SPEC_2_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/out_2 )
SET_TESTS_PROPERTIES(TEST_PHASE_ZERO_LINEAR_SPEC_2_DIFF PROPERTIES DEPENDS TEST_MCHK_PHASE_ZERO_LINEAR_SPEC_2 )


##############################
#   Image linear phase test: 
##############################
SET( TEST_NAME TEST_MCHK_EVEN_IMAGE_LINEAR_PHASE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_linear_phase)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageLinearPhaseTest ${TEST_CASE_ROOT}/input/testBoxEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_IMAGE_LINEAR_PHASE_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_IMAGE_LINEAR_PHASE_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_IMAGE_LINEAR_PHASE)


##############################
#   Image linear phase test: 
##############################
SET( TEST_NAME TEST_MCHK_ODD_IMAGE_LINEAR_PHASE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_linear_phase)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageLinearPhaseTest ${TEST_CASE_ROOT}/input/testBoxOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_IMAGE_LINEAR_PHASE_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_IMAGE_LINEAR_PHASE_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_IMAGE_LINEAR_PHASE)


##############################
#   sinc interpolate test for even data set: 
##############################
SET( TEST_NAME TEST_MCHK_EVEN_SINC_INTERPOLATE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sinc_interpolate)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkSincInterpolateTest ${TEST_CASE_ROOT}/input/testBoxCenterEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_SINC_INTERPOLATE_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_SINC_INTERPOLATE_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_SINC_INTERPOLATE)

##############################
#   sinc interpolate test for odd data set: 
##############################
SET( TEST_NAME TEST_MCHK_ODD_SINC_INTERPOLATE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sinc_interpolate)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkSincInterpolateTest ${TEST_CASE_ROOT}/input/testBoxCenterOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_SINC_INTERPOLATE_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_SINC_INTERPOLATE_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_SINC_INTERPOLATE)


########################
#   Data combining test: 
########################
SET( TEST_NAME TEST_MCHK_COMBINE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/combining)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsCombine ${TEST_CASE_ROOT}/input/phantom_8ch.dcm ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_COMBINE_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_COMBINE_DIFF PROPERTIES DEPENDS TEST_MCHK_COMBINE)


########################
#   Read Sym EPSI data test: 
########################
SET( TEST_NAME TEST_MCHK_READ_SYM_EPSI)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sym_epsi)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/c13_3d_raw -o ${TEST_RESULTS_PATH}/out -t2 --no_dc_correction )

SET( TEST_NAME TEST_READ_SYM_EPSI_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/out_nodc)
SET_TESTS_PROPERTIES(TEST_READ_SYM_EPSI_DIFF PROPERTIES DEPENDS TEST_MCHK_READ_SYM_EPSI)

########################
#   Read Sym EPSI Dynamic data test: 
########################
SET( TEST_NAME TEST_MCHK_READ_SYM_EPSI_DYNAMIC)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sym_epsi_dynamic)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/dyn01 -o ${TEST_RESULTS_PATH}/out -t2  --no_dc_correction)

SET( TEST_NAME TEST_READ_SYM_EPSI_DYNAMIC_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/out_nodc)
SET_TESTS_PROPERTIES(TEST_READ_SYM_EPSI_DYNAMIC_DIFF PROPERTIES DEPENDS TEST_MCHK_READ_SYM_EPSI_DYNAMIC)


########################
#   Read GE .shf file (sdbm) test: 
########################
SET( TEST_NAME TEST_MCHK_READ_GE_SHF )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_sdbm_files )
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/test.shf -o ${TEST_RESULTS_PATH}/out -t2 )

SET( TEST_NAME TEST_READ_GE_SHF_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output )
SET_TESTS_PROPERTIES(TEST_READ_GE_SHF_DIFF PROPERTIES DEPENDS TEST_MCHK_READ_GE_SHF)


########################
#   Convert GE Postage Stamp file to DDF test:
########################
SET( TEST_NAME TEST_MCHK_GE_POSTAGE_TO_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_postage_stamp)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/000001.DCM -o ${TEST_RESULTS_PATH}/out -t2 )

SET( TEST_NAME TEST_GE_POSTAGE_TO_DDF_DIFF )
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/output )
SET_TESTS_PROPERTIES(TEST_GE_POSTAGE_TO_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_GE_POSTAGE_TO_DDF)


########################
#   apodization test: 
########################
SET( TEST_NAME TEST_MCHK_MRS_APODIZATION)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_apodization)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsApodizationFilterTest  ${SVK_TEST_ROOT}/ge_pfiles/20x/input/20_x_raw ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_MRS_APODIZATION_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/out )
SET_TESTS_PROPERTIES(TEST_MRS_APODIZATION_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_APODIZATION)


########################
#   multi-volume DICIOM 2 IDF test: 
########################
SET( TEST_NAME TEST_MCHK_MULTI_VOL_DCM_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/multi_volume)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E10755S2I1.DCM -o ${TEST_RESULTS_PATH}/out -t3 )

SET( TEST_NAME TEST_MULTI_VOL_DCM_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output_dcm )
SET_TESTS_PROPERTIES(TEST_MULTI_VOL_DCM_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_MULTI_VOL_DCM_2_IDF)


########################
#   multi-volume IDF 2 IDF test: 
########################
SET( TEST_NAME TEST_MCHK_MULTI_VOL_IDF_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/multi_volume)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/vol_1.idf -o ${TEST_RESULTS_PATH}/out -t3 )

SET( TEST_NAME TEST_MULTI_VOL_IDF_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output_idf )
SET_TESTS_PROPERTIES(TEST_MULTI_VOL_IDF_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_MULTI_VOL_IDF_2_IDF)

########################
#   multi-volume IDF 2 DICOM test: 
########################
SET( TEST_NAME TEST_MCHK_MULTI_VOL_IDF_2_DCM)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/multi_volume)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/vol_1.idf -o ${TEST_RESULTS_PATH}/out -t5 )

SET( TEST_NAME TEST_MULTI_VOL_IDF_2_DCM_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/output_idf_to_dcm --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_MULTI_VOL_IDF_2_DCM_DIFF PROPERTIES DEPENDS TEST_MCHK_MULTI_VOL_IDF_2_DCM)

########################
#   multi-volume IDF 2 DICOM Enhanced test: 
########################
SET( TEST_NAME TEST_MCHK_MULTI_VOL_IDF_2_DCMENH)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/multi_volume)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/vol_1.idf -o ${TEST_RESULTS_PATH}/out -t6 )

SET( TEST_NAME TEST_MULTI_VOL_IDF_2_DCMENH_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/output_idf_to_dcmenh --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_MULTI_VOL_IDF_2_DCMENH_DIFF PROPERTIES DEPENDS TEST_MCHK_MULTI_VOL_IDF_2_DCMENH)


########################
#   multi-volume DICOM Enhanced 2 DICOM Enhanced test: 
########################
SET( TEST_NAME TEST_MCHK_MULTI_VOL_DCMENH_2_DCMENH)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/multi_volume)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/enh.dcm -o ${TEST_RESULTS_PATH}/out -t6 )

SET( TEST_NAME TEST_MULTI_VOL_DCMENH_2_DCMENH_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/output_dcmenh_to_dcmenh --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_MULTI_VOL_DCMENH_2_DCMENH_DIFF PROPERTIES DEPENDS TEST_MCHK_MULTI_VOL_DCMENH_2_DCMENH)

########################
#   multi-volume DICOM Enhanced 2 DICOM Enhanced test: 
########################
SET( TEST_NAME TEST_MCHK_FLOAT_DCMENH_2_DCMENH)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/enhanced_dicom)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/float.dcm -o ${TEST_RESULTS_PATH}/out -t6 )

SET( TEST_NAME TEST_FLOAT_DCMENH_2_DCMENH_DIFF)
ADD_TEST(${TEST_NAME}  perl ${TEST_SCRIPT_PATH}/dcm2xml_series_diff --diff ${DIFF_COMMAND} --dir_one ${TEST_RESULTS_PATH} --dir_two ${TEST_CASE_ROOT}/${TEST_PLATFORM}/output_float --bin_dir ${DCMTK_DIR}/bin --diff_opts ${DIFF_OPT_DCM_STR} )
SET_TESTS_PROPERTIES(TEST_FLOAT_DCMENH_2_DCMENH_DIFF PROPERTIES DEPENDS TEST_MCHK_FLOAT_DCMENH_2_DCMENH)

########################
#   Reorder flyback data
########################
SET( TEST_NAME TEST_MCHK_REORDER_FLYBACK)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sample_epsi)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_reorder_epsi -i ${TEST_CASE_ROOT}/input/t4807_lac_1.ddf -o ${TEST_RESULTS_PATH}/out -t2 --lobes 712  --skip 7 --axis 3 --type 1)

SET( TEST_NAME TEST_REORDER_FLYBACK_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out)
SET_TESTS_PROPERTIES(TEST_REORDER_FLYBACK_DIFF PROPERTIES DEPENDS TEST_MCHK_REORDER_FLYBACK)

########################
#   Reorder interleaved EPSI data
########################
SET( TEST_NAME TEST_MCHK_REORDER_INTERLEAVED_EPSI)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sample_epsi)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input_interleaved/t8000_2coil -o ${TEST_RESULTS_PATH}/out_interleaved -t2 --epsi_lobes 552 --epsi_skip 7 --epsi_axis 2 --epsi_type 3)

SET( TEST_NAME TEST_REORDER_INTERLEAVED_EPSI_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${TEST_PLATFORM}/out_interleaved)
SET_TESTS_PROPERTIES(TEST_REORDER_INTERLEAVED_EPSI_DIFF PROPERTIES DEPENDS TEST_MCHK_REORDER_INTERLEAVED_EPSI)

########################
#   DICOM raw writer: 
#   dcm file is created 
#   in same dir as raw file, thus the
#   link. 
########################
SET( TEST_NAME TEST_MCHK_DICOM_RAW_WRITER )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/raw_dicom )

ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_create_dcmraw -i ${TEST_RESULTS_PATH}/20_x_raw )

IF(WIN32)
    EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different  ${SVK_TEST_ROOT}/raw_dicom/input/20_x_raw ${TEST_RESULTS_PATH}/20_x_raw  )
ELSE(WIN32)
    SET( TEST_RAW_RMLINK_COMMAND "/bin/rm" ) 
    SET( TEST_NAME_RMLINK TEST_RAW_RMLINK )
    ADD_CUSTOM_TARGET( ${TEST_NAME_RMLINK} ${TEST_RAW_RMLINK_COMMAND} -f ${TEST_RESULTS_PATH}/20_x_raw ) 

    SET( TEST_RAW_LINK_COMMAND "/bin/ln" ) 
    SET( TEST_NAME_LINK TEST_RAW_LINK )
    ADD_CUSTOM_TARGET( ${TEST_NAME_LINK} ALL ${TEST_RAW_LINK_COMMAND} -s ${SVK_TEST_ROOT}/raw_dicom/input/20_x_raw  ${TEST_RESULTS_PATH}/20_x_raw  ) 
    ADD_DEPENDENCIES(${TEST_NAME_LINK} ${TEST_NAME_RMLINK})
    ADD_DEPENDENCIES( ExperimentalBuild ${TEST_NAME_LINK})
    SET_TESTS_PROPERTIES(${TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME_LINK})
ENDIF(WIN32)


SET( TEST_NAME TEST_DICOM_RAW_WRITER_DIFF)
ADD_TEST( ${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} ${TEST_RESULTS_PATH}/20_x_raw.dcm ${TEST_CASE_ROOT}/input/20_x_raw.dcm )
SET_TESTS_PROPERTIES(TEST_DICOM_RAW_WRITER_DIFF PROPERTIES DEPENDS TEST_MCHK_DICOM_RAW_WRITER)

########################
#   DICOM raw writer: 
#   dcm file is created 
#   in same dir as raw file, thus the
#   link. 
########################
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/TEST_MCHK_DICOM_RAW_WRITER_2 )
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/raw_dicom )


IF(WIN32)
    EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different   ${SVK_TEST_ROOT}/raw_dicom/input_2/P1  ${TEST_RESULTS_PATH}  )
    EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different   ${SVK_TEST_ROOT}/raw_dicom/input_2/P1.dat  ${TEST_RESULTS_PATH}  )
    EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different   ${SVK_TEST_ROOT}/raw_dicom/input_2/P1_press_box.dat  ${TEST_RESULTS_PATH}  )
    EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different   ${SVK_TEST_ROOT}/raw_dicom/input_2/P1_sat_bands.dat  ${TEST_RESULTS_PATH}  )
	EXECUTE_PROCESS( COMMAND ${CMAKE_COMMAND} -E copy_if_different   ${SVK_TEST_ROOT}/raw_dicom/input_2/${TEST_PLATFORM}/P1.dcm  ${TEST_RESULTS_PATH}  )
ELSE(WIN32)
    SET( RAW_LINK_TARGET TEST_RAW_LINK_CMD )
    SET( TEST_RAW_LINK_COMMAND "${TEST_SCRIPT_PATH}/raw_links" ) 
    ADD_CUSTOM_TARGET( ${RAW_LINK_TARGET} ALL ${TEST_RAW_LINK_COMMAND} --src_dir ${SVK_TEST_ROOT}/raw_dicom/input_2/ --raw_root P1 --target_dir ${TEST_RESULTS_PATH}/ ) 
    ADD_DEPENDENCIES( ExperimentalBuild ${RAW_LINK_TARGET})
ENDIF(WIN32)

SET( TEST_NAME TEST_MCHK_DICOM_RAW_WRITER_2 )
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_create_dcmraw -i ${TEST_RESULTS_PATH}/P1 -a ${TEST_RESULTS_PATH}/P1.dat -a ${TEST_RESULTS_PATH}/P1_press_box.dat -a ${TEST_RESULTS_PATH}/P1_sat_bands.dat )
SET_TESTS_PROPERTIES(TEST_MCHK_DICOM_RAW_WRITER_2 PROPERTIES DEPENDS TEST_RAW_LINK_CMD)

SET( TEST_NAME TEST_DICOM_RAW_WRITER_DIFF_2)
ADD_TEST( ${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} ${TEST_RESULTS_PATH}/P1.dcm ${TEST_CASE_ROOT}/input_2/${TEST_PLATFORM}/P1.dcm )
SET_TESTS_PROPERTIES(TEST_DICOM_RAW_WRITER_DIFF_2 PROPERTIES DEPENDS TEST_MCHK_DICOM_RAW_WRITER_2)

SET( TEST_NAME TEST_DICOM_RAW_WRITER_EXTRACT)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_create_dcmraw -i ${TEST_RESULTS_PATH}/P1.dcm -o ${TEST_RESULTS_PATH} -x )
SET_TESTS_PROPERTIES(TEST_DICOM_RAW_WRITER_EXTRACT PROPERTIES DEPENDS TEST_MCHK_DICOM_RAW_WRITER_DIFF_2)


########################
#   HSVD test: 
########################
SET( TEST_NAME TEST_HSVD)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/hsvd )
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_hsvd -i ${TEST_CASE_ROOT}/input/20x_1reconFREQ.ddf -o${TEST_RESULTS_PATH}/hsvdout -t 2 )

SET( TEST_NAME TEST_HSVD_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output )
SET_TESTS_PROPERTIES(TEST_HSVD_DIFF PROPERTIES DEPENDS TEST_HSVD)

if ( BUILD_ITK )
    ########################
    #   First Point Phase Test (-a1): 
    ########################
    SET( TEST_NAME TEST_FP_PHASE )
    SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
    file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
    SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/phase )
    ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_auto_phase -a1 -i ${TEST_CASE_ROOT}/input_fp/infp.ddf -o${TEST_RESULTS_PATH}/outfp -t 2 )

    SET( TEST_NAME TEST_FP_PHASE_DIFF)
    ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_fp )
    SET_TESTS_PROPERTIES(TEST_FP_PHASE_DIFF PROPERTIES DEPENDS TEST_FP_PHASE)
endif ( BUILD_ITK )

########################
#   Bruker DICOM MRS Reader 
########################
SET( TEST_NAME TEST_BRUKER_2_DCM)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY ${TEST_RESULTS_PATH} )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/bruker)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/MRIm0001 -o${TEST_RESULTS_PATH}/MRIm.dcm -t 4 )

SET( TEST_NAME TEST_BRUKER_2_DCMMRS_XML)
ADD_TEST(${TEST_NAME} ${DCM_2_XML_COMMAND} +M +Wb ${TEST_RESULTS_PATH}/MRIm.dcm ${TEST_RESULTS_PATH}/MRIm.xml ) 
SET_TESTS_PROPERTIES(TEST_BRUKER_2_DCMMRS_XML PROPERTIES DEPENDS TEST_BRUKER_2_DCM)

SET( TEST_NAME TEST_BRUKER_2_DCM_DIFF)
ADD_TEST(${TEST_NAME}  ${DIFF_COMMAND} ${DIFF_OPT_DCM} -r ${TEST_RESULTS_PATH}/MRIm.xml ${TEST_CASE_ROOT}/output/MRIm.xml)
SET_TESTS_PROPERTIES(TEST_BRUKER_2_DCM_DIFF PROPERTIES DEPENDS TEST_BRUKER_2_DCMMRS_XML )


