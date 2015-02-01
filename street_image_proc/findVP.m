function [ vp,verla ] = findVP( img,lines,labels )
vp=zeros(max(labels),2);
for nowlabel=1:max(labels)
    nowlines=lines(find(labels==nowlabel),:);
    if size(nowlines,1)<2
        continue;
    end
    %get all lines and lengths
    ls=[];
    lslen=[];
    for ii=1:size(nowlines,1)
        ls=[ls;cross([nowlines(ii,1:2),1],[nowlines(ii,3:4),1])];
        lslen=[lslen;sqrt((nowlines(ii,3)-nowlines(ii,1))^2+(nowlines(ii,4)-nowlines(ii,2))^2)];
    end
    %ransac
    runtime=300;
    inlierthres=50;
    choices=[];
    scores=[];
    vprounds=[];
    for runs=1:runtime
        while 1
            choice=ceil(rand(1,2)*size(nowlines,1));
            choice(choice==0)=1;
            if choice(1)~=choice(2)
                break;
            end
        end
        choices=[choices;choice];
        l1=ls(choice(1),:);
        l2=ls(choice(2),:);
        nowvphomo=cross(l1,l2);
        nowvp=[nowvphomo(1)/nowvphomo(3),nowvphomo(2)/nowvphomo(3)];
        lsdis=abs(ls(:,1)*nowvp(1)+ls(:,2)*nowvp(2)+ls(:,3))./sqrt(ls(:,1).^2+ls(:,2).^2);
        scores=[scores;sum(lslen(lsdis<inlierthres))];
        vprounds=[vprounds;nowvp];
    end
    bestransacs=find(scores==max(scores));
    bestransacs=bestransacs(1);
    vp(nowlabel,1:2)=vprounds(bestransacs,:);
end
%find vertical vp
vervps=[];
verlas=[];
lanums=[];
for ii=1:size(vp,1)
    if (vp(ii,1)>0) && (vp(ii,1)<size(img,2)) && (vp(ii,2)<0)
        vervps=[vervps;vp(ii,:);];
        verlas=[verlas;ii;];
        lanums=[lanums;sum(labels==ii);];
    end
end
if size(verlas,1)>1
    [lanum,ind]=max(lanums);
    vervp=vervps(ind,:);
    verla=verlas(ind);
else
    vervp=vervps;
    verla=verlas;
end
%if vertical vp at infinite
if isempty(verlas)
    slos=zeros(1,max(labels));
    for nowlabel=1:max(labels)
        nowlines=lines(find(labels==nowlabel),:);
        slos(nowlabel)=mean(abs((nowlines(:,4)-nowlines(:,2))./(nowlines(:,3)-nowlines(:,1))));
    end
    [dummymax,verla]=max(slos);
    vp(verla,:)=[size(img,2)/2,-100000];
else
    %calibrate vertical vp, assuming in the center
    verlines=lines(find(labels==verla),:);
    centerline=cross([size(img,2)/2,1,1],[size(img,2)/2,100,1]);
    hei=[];
    wei=[];
    for ii=1:size(verlines,1)
        nowl=cross([verlines(ii,1:2),1],[verlines(ii,3:4),1]);
        interhomo=cross(nowl,centerline);
        interhei=interhomo(2)/interhomo(3);
        if interhei<0
            thiswei=sqrt((verlines(ii,3)-verlines(ii,1))^2+(verlines(ii,4)-verlines(ii,2))^2);
            wei=[wei,thiswei];
            hei=[hei,interhei];
        end
    end
    for ii=1:length(hei)
        inlinewei(ii)=sum(wei(abs(hei-hei(ii))<80));
    end
    [dummymax,which]=max(inlinewei);
    vp(verla,:)=[size(img,2)/2,hei(which)];
    for ii=1:size(vp,1)
        if vp(ii,2)==-Inf
            vp(ii,2)=-100000;
        end
    end
end
end