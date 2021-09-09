import os
import sys
import math
import numpy as np
import time
import os.path

from OMPython import OMCSessionZMQ

start = time.time()

try:
    samples = sys.argv[1]
    tests = sys.argv[2]
except IndexError:
    print("missing arguments: <number of samples> <number of tests>")
    exit()

print("removing old System (if any) ...")
os.system("rm -f ./System")    # remove previous executable, if any.
print("done!")

omc = OMCSessionZMQ()
omc.sendExpression("getVersion()")
omc.sendExpression("cd()")

print("load Modelica")
omc.sendExpression("loadModel(Modelica)")
omc.sendExpression("getErrorString()")

print("load Connectors.mo")
omc.sendExpression("loadFile(\"Connectors.mo\")")
omc.sendExpression("getErrorString()")

print("load System.mo")
omc.sendExpression("loadFile(\"System.mo\")")
omc.sendExpression("getErrorString()")

print("load Aula.mo")
omc.sendExpression("loadFile(\"Aula.mo\")")
omc.sendExpression("getErrorString()")

print("load Studenti.mo")
omc.sendExpression("loadFile(\"Studenti.mo\")")
omc.sendExpression("getErrorString()")

print("load Prenotazioni.mo")
omc.sendExpression("loadFile(\"Prenotazioni.mo\")")
omc.sendExpression("getErrorString()")

print("load GOMP.mo")
omc.sendExpression("loadFile(\"GOMP.mo\")")
omc.sendExpression("getErrorString()")

print("load Prodigit.mo")
omc.sendExpression("loadFile(\"Prodigit.mo\")")
omc.sendExpression("getErrorString()")

print("load Monitor_RF.mo")
omc.sendExpression("loadFile(\"Monitor_RF.mo\")")
omc.sendExpression("getErrorString()")

print("load Monitor_RNF.mo")
omc.sendExpression("loadFile(\"Monitor_RNF.mo\")")
omc.sendExpression("getErrorString()")

print("load Functions.mo")
omc.sendExpression("loadFile(\"Functions.mo\")")
omc.sendExpression("getErrorString()")

print("buildModel(System, stopTime="+str(samples)+")")
omc.sendExpression("buildModel(System, stopTime="+str(samples)+")")
omc.sendExpression("getErrorString()")


pass_count = 0
error_count = 0


with open ("log_verify.txt", 'wt') as f:
    f.write("Begin log\n")
    print("\nBegin log\n")
    f.flush()
    os.fsync(f)

for i in range(int(tests)):
    aula_local_seed = int(np.random.uniform(1,10000))
    studenti_local_seed = int(np.random.uniform(1,10000))
    GOMP_local_seed = int(np.random.uniform(1,10000))
    
    with open ("parameters.txt", 'wt') as f:                
        f.write("a.localSeed="+str(aula_local_seed)+"\n"+"s.localSeed="+str(studenti_local_seed)+"\n"+"G.localSeed="+str(GOMP_local_seed)+"\n")
        f.flush()
        os.fsync(f)
        
    with open ("log_verify.txt", 'a') as f:
        f.write("\nTest "+str(i)+":\n")
        f.write("Variables: a.localSeed="+str(aula_local_seed)+" s.localSeed="+str(studenti_local_seed)+" G.localSeed"+str(GOMP_local_seed)+"\n")
        print("Test "+str(i)+":")
        print("Variables: a.localSeed="+str(aula_local_seed)+" s.localSeed="+str(studenti_local_seed)+" G.localSeed="+str(GOMP_local_seed))
        f.flush()
        os.fsync(f)
        
        os.system("./System -overrideFile=parameters.txt >> log_verify.txt")
        time.sleep(1.0)
        safety_signal = omc.sendExpression("val(m_rf.safety_signal, "+str(samples)+", \"System_res.mat\")")
    
        if(safety_signal == False):
            pass_count+=1
            f.write("Esit: SUCCESS\n")
            print("Esit: SUCCESS\n")
        else:
            error_count+=1
            f.write("Esit: FAIL\n")
            print("Esit: FAIL\n")

os.system("rm parameters.txt");

with open ("log_verify.txt", 'a') as f:
    f.write("\ntest superati: "+str(pass_count)+"\n")
    f.write("test falliti: "+str(error_count)+"\n")
    print("test superati: "+str(pass_count))
    print("test falliti: "+str(error_count))
    f.flush()
    os.fsync(f)
    
end = time.time()

print("Runtime of the program is "+str(end-start))





