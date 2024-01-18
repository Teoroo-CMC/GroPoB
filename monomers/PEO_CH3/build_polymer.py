#!/usr/bin/python3
import numpy as np
import os
from ase.io import read
from ase.visualize import view

poly=input("Polymer abbrevation? (3 or 4 letters and preferable in caps): ") or "PCL"
charge=input("Charge of the molecule: ") or "0"

print(poly,charge)
### Parameterize for monomer 
#os.popen('./acpype.py -i '+str(poly)+'_monomer.pdb -b '+str(poly)+' -n '+str(charge)) 
#os.popen('cp '+str(poly)+'.acpype/ANTECHAMBER_AC.AC .')
os.popen('mv ANTECHAMBER_AC.AC '+str(poly)+'.ac')

###Atom names and types are in poly.ac file
#### Check the atom indices from pdb file
mol=read(str(poly)+'_monomer.pdb')
view(mol)
ac=open(str(poly)+'.ac',mode='r')
[next(ac) for _ in range(2)]
l=ac.readlines()
chain=open(str(poly)+'.chain','w+');head=open(str(poly)+'.head','w+');tail=open(str(poly)+'.tail','w+')

head_id=int(input("Head atom index: ") or 0)
tail_id=int(input("Tail atom index: ") or 13)

chain.write('HEAD_NAME '+str(l[head_id].split()[2])+'\n')
tail.write('HEAD_NAME '+str(l[head_id].split()[2])+'\n')
chain.write('TAIL_NAME '+str(l[tail_id].split()[2])+'\n')
head.write('TAIL_NAME '+str(l[tail_id].split()[2])+'\n')

head_omit=input("Atom indices to omit near head: ").split() or [18, 23, 24, 25]
tail_omit=input("Atom indices to omit near tail: ").split() or [16, 20, 21, 22]

for i in range(len(head_omit)):
	chain.write('OMIT_NAME '+str(l[int(head_omit[i])].split()[2])+'\n')
	tail.write('OMIT_NAME '+str(l[int(head_omit[i])].split()[2])+'\n')
chain.write('PRE_HEAD_TYPE '+str(l[tail_id].split()[9])+'\n')
tail.write('PRE_HEAD_TYPE '+str(l[tail_id].split()[9])+'\n')
tail.write('CHARGE '+str(charge))

for i in range(len(tail_omit)):
	chain.write('OMIT_NAME '+str(l[int(tail_omit[i])].split()[2])+'\n')
	head.write('OMIT_NAME '+str(l[int(tail_omit[i])].split()[2])+'\n')
chain.write('POST_TAIL_TYPE '+str(l[head_id].split()[9])+'\n')
chain.write('CHARGE '+str(float(charge)))
head.write('POST_TAIL_TYPE '+str(l[head_id].split()[9])+'\n')
head.write('CHARGE '+str(float(charge)))

chain.close();head.close();tail.close()

os.popen('prepgen -i '+str(poly)+'.ac -o '+str(poly)+'.prepi -f prepi -m '+str(poly)+'.chain -rn '+str(poly)+' -rf '+str(poly)+'.res') 
os.popen('prepgen -i '+str(poly)+'.ac -o HPT.prepi -f prepi -m '+str(poly)+'.head -rn HPT -rf HPT.res') 
os.popen('prepgen -i '+str(poly)+'.ac -o TPT.prepi -f prepi -m '+str(poly)+'.tail -rn TPT -rf TPT.res') 

n_mono=int(input("Number of monomers in the polymer: ") or 2)
repeat=" ".join([poly] * int(n_mono-2))
tleap=open(str(poly)+'_tleap.in','w+')
tleap.write('source leaprc.gaff'+'\n'+
			'loadamberprep '+str(poly)+'.prepi'+'\n'+
			'loadamberprep HPT.prepi'+'\n'+
			'loadamberprep TPT.prepi'+'\n'+
			'mol = sequence {HPT '+str(repeat)+' TPT}'+'\n'+
			'savepdb mol '+str(poly)+'_polymer.pdb'+'\n'+
			'saveamberparm mol '+str(poly)+'_polymer.prmtop '+str(poly)+'_polymer.inpcrd'+'\n'+
			'quit'
			)		
tleap.close()

os.popen('tleap -s -f '+str(poly)+'_tleap.in > '+str(poly)+'_tleap.out')
#os.popen('./acpype.py -p '+str(poly)+'_polymer.prmtop -x '+str(poly)+'_polymer.inpcrd')
