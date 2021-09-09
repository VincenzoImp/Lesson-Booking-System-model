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

min_prodigit_T = 1.0
max_prodigit_T = 1.0*60*24
delta = (max_prodigit_T-min_prodigit_T)/(int(tests)-1)
            
max_y = -1
best_prodigit_T = -1

with open ("log_synth.txt", 'wt') as f:
    f.write("Begin log\n")
    print("\nBegin log\n")
    f.flush()
    os.fsync(f)

for i in range(int(tests)):
    
    prodigit_T = min_prodigit_T + delta*i
    
    with open ("parameters.txt", 'wt') as f:                
        f.write("prod.T="+str(prodigit_T)+"\n")
        f.flush()
        os.fsync(f)
        
    with open ("log_synth.txt", 'a') as f:
        f.write("\nTest "+str(i)+":\n")
        f.write("Variables: prod.T = "+str(prodigit_T)+"\n")
        print("Test "+str(i)+":")
        print("Variables: prod.T = "+str(prodigit_T))
        f.flush()
        os.fsync(f)
        
        os.system("./System -overrideFile=parameters.txt >> log_synth.txt")
        time.sleep(1.0)
        stato_differente = omc.sendExpression("val(m_rnf.stato_differente, "+str(samples)+", \"System_res.mat\")")
        capienza_differente = omc.sendExpression("val(m_rnf.capienza_differente, "+str(samples)+", \"System_res.mat\")")
        max_delta_error_prenotazioni = omc.sendExpression("val(m_rnf.max_delta_error_prenotazioni, "+str(samples)+", \"System_res.mat\")")
        
        print(stato_differente, capienza_differente, max_delta_error_prenotazioni)
        y = 500*stato_differente + 500*capienza_differente + max_delta_error_prenotazioni**2 + 10*(int(tests) - (i+1))
        if y != 0: y = 1/y
        
        f.write("Esit: objective function = "+str(y)+"\n")
        print("Esit: objective function = "+str(y)+"\n")
        
        if(y >= max_y):
            max_y = y
            best_prodigit_T = prodigit_T
            
os.system("rm parameters.txt");

with open ("log_synth.txt", 'a') as f:
    f.write("\nmin(objective function): "+str(max_y)+"\n")
    f.write("best prod.T value: "+str(best_prodigit_T)+"\n")
    print("min(objective function): "+str(max_y))
    print("best prod.T value: "+str(best_prodigit_T))
    f.flush()
    os.fsync(f)
    
end = time.time()

print("Runtime of the program is "+str(end-start))





