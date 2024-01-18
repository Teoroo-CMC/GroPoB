#import *
import numpy as np
import os
import nglview as ngl

SYSDIR='/home/harish/GroPolBul'
    
##Give short polymer name and charge
res=input("Polymer abbrevation? (3 or 4 letters and preferable in caps): ") or "PE"
end=input("End group? (3 or 4 letters and preferable in caps): ") or "OH"
chg=input("Charge of the molecule: ") or "0"
print(res,end,chg)
MONDIR=str(SYSDIR)+'/monomers/'+str(res)+'_'+str(end)
os.popen('mkdir '+str(MONDIR)).read()
os.chdir(str(MONDIR))

##Paramaterize the monomer with acpype
mono=input("Monomer mol2 file or SMILE fomat: ") or "OCCCCCCCCCCCCO"
#os.popen('rm -r '+str(res)+'.acpype')
#os.popen('acpype -i '+str(mono)+' -b '+str(res)+' -n '+str(chg)+' -o gmx').read()
os.popen("sed -e 's/UNL/"+str(res)+"/g' "+str(res)+".acpype/sqm.pdb > "+str(res)+".pdb").read()
os.popen("sed -e 's/UNL/"+str(res)+"/g' "+str(res)+".acpype/ANTECHAMBER_AC.AC > "+str(res)+".ac").read()

#Visualize the molecule
mol=read(str(res)+'.acpype/PE_GMX.gro')
vi=ngl.show_ase(mol);vi.add_label(radius=2,color='black',label_type='atomindex')
vi
