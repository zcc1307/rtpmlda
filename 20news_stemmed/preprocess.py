f = open('20ng-train-stemmed.txt');

voc = {};
ind = {};
wordlist = [];

new = 1;
for line in f:
    k = line.strip().split(" ");
    k = k[1:len(k)];
    for word in k:
        if word not in voc:
            voc[word] = 1;
            wordlist.append(word);
            ind[word] = new;
            new += 1;
        else:
            voc[word] = voc[word]+1;
f.close();



fw = open('20new_voc.txt','w');
for word in wordlist:
    fw.write(word);
    fw.write('\n');
    
fw.close();


f = open('20ng-train-stemmed.txt');
fw = open('20news_terms.txt','w');

i = 1;
for line in f:
    k = line.strip().split(" ");
    k = k[1:len(k)];
    
    tempvoc = {};
    for word in k:
        if word not in tempvoc:
            tempvoc[word] = 1;
        else:
            tempvoc[word] = tempvoc[word] + 1;

    for word in tempvoc:
        fw.write(str(i)+' '+str(ind[word])+' '+str(tempvoc[word])+'\n');

    i += 1;


f.close();
fw.close();
        
