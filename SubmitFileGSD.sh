## External vars
curDir=${1}
outDir=${2}
cfgFile=${3}
localFlag=${4}
CMSSWVER=${5} # CMSSW_8_1_0_pre7
CMSSWDIR=${6} # ${curDir}/../${CMSSWVER}
CMSSWARCH=${7} # slc6_amd64_gcc530
eosArea=${8}
dataTier=${9}

##Create Work Area
export SCRAM_ARCH=${CMSSWARCH}
source /afs/cern.ch/cms/cmsset_default.sh
eval `scramv1 project CMSSW ${CMSSWVER}`
cd ${CMSSWVER}/
rm -rf ./*
cp -r -d ${CMSSWDIR}/* ./
cd src
eval `scramv1 runtime -sh`
edmPluginRefresh -p ../lib/$SCRAM_ARCH

## Execute job and retrieve the outputs
echo "Job running on `hostname` at `date`"

cmsRun ${curDir}/${outDir}/cfg/${cfgFile}

# copy to outDir in curDir or at given EOS area
if [ ${localFlag} == "True" ]
  then
    cp *${dataTier}*.root ${curDir}/${outDir}/${dataTier}/
  else
    xrdcp -N -v *${dataTier}*.root root://eoscms.cern.ch/${eosArea}/${outDir}/${dataTier}/
fi