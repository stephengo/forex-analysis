a = csvread('allcrosses.csv',1,1);
etf = readtable('ETFs.csv');
dates = csvread('allcrosses.csv',1);

crqb = csvread('crqb.csv',1,1);
closing = crqb(:,4);
closingd = csvread('crqb.csv',1);
closingd = closingd(:,1);
%t2 = datestr(closingd,'mm/dd/yyyy');
%t2 = datetime(closingd,'ConvertFrom','dd-MMM-yyyy');
%plot(t2,closingd);

%This takes the first row and makes labels
cross = fopen('allcrosses.csv');
c = textscan(cross,'%s',1);
test = c{1}{1};
fclose(cross);
toLabel = textscan(test,'%s',172,'Delimiter',',');
toLabel = toLabel{1};
Label = toLabel(2:172,:);
Label = cellstr(Label);
Labels = cellstr(Label); %These are the labels for the bi-plots

cor = corr(a,a);
dates = dates(:,1);
crosses = cross(1,:);
[wcoeff,score,latent,tsquared,explained] = pca(a);

B = rotatefactors(wcoeff);

%loadings is the wcoeff or principal component coefficients
s = wcoeff;

x = s(:,1); %PC1
y = s(:,2); %PC2
z = s(:,3); %PC3
q = s(:,4); %PC4

%bi-plot1

ax = gca;
scatter(x,y,'d','filled') %comparing PC1 and PC2 loadings
ax.XAxisLocation = 'origin';
text(x, y, Labels, 'horizontal','left', 'vertical','bottom');

%bi-plot2

%scatter(x,z,'d','filled') %PC1 and PC3
%ax.XAxisLocation = 'origin';
%text(x, z, Labels,'horizontal','left','vertical','bottom');

%bi-plot3

%scatter(x,q,'d','filled') %PC1 and PC4
%ax.XAxisLocation = 'origin';
%text(x, q, Labels,'horizontal','left','vertical','bottom');

%this stores the returns on every 7th day
%Just a test, this is not being used.
% i = 7;
% byweek = [];
% while i < 2666
%     byweek1 = a(i,:);
%     byweek = vertcat(byweek,byweek1);
%     
%     i = i + 7;
% end

%this loop sums the returns for each cross every 7 days
rows = 1;
num = 1;
rownum = 1;
rowval = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
totalret = [];
while rows < 2666;
    while num < 7;
        rowval = rowval + a(rownum,:);
        num = num + 1;
        rownum = rownum + 1;
    end
    totalret = vertcat(totalret,rowval);
    rowval = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    num = 1;
    rows = rows + 7;
end

%This loop generates the values for proportion of variance explained by PC1
%over time based on a 52-week rolling window.
begrow = 380;
endrow = 328;
finexpl = [];
finexpl2 = [];
score1 = [];
while endrow > 0
    [wcoeff,score,latent,tsquared,explained] = pca(totalret(endrow:begrow,:));
    begrow = begrow - 1;
    endrow = endrow - 1;
    finexpl = vertcat(finexpl,explained(1));
    finexpl2 = vertcat(finexpl2,explained(2));
    score1 = vertcat(score1,score(2));
end

%this will generate the values for each week, size is 381 which will be
%the same as our weekly return vector size. However, we will not use all
%weeks since a rolling window is in effect.
day = 1;
weeks = [];
while day < 2666
    weeks = vertcat(weeks,dates(day));
    day = day + 7;
end

%takes the latest dates up to week 328, does not include first 52 weeks
daterange = weeks(1:328);
t = datetime(daterange,'ConvertFrom','yyyymmdd');

%This plots the percentage of variation from PC1 over time
%plot(t,finexpl);

%This plot the percentage of variation of PC1 and PC2 over time
%plot(t,[finexpl,finexpl2]);
r = corrcoef(finexpl,finexpl2);

%PC1 laodings plotted over time
begrow = 380;
endrow = 328;
load1roll = [];
while endrow > 0
    [wcoeff,score,latent,tsquared,explained] = pca(totalret(endrow:begrow,:));
    begrow = begrow - 1;
    endrow = endrow - 1;
    load1roll = vertcat(load1roll,wcoeff(1));
end

%PC2 loadings plotted over time
begrow = 380;
endrow = 328;
load2roll = [];
while endrow > 0
    [wcoeff,score,latent,tsquared,explained] = pca(totalret(endrow:begrow,:));
    begrow = begrow - 1;
    endrow = endrow - 1;
    load2roll = vertcat(load2roll,wcoeff(2));
end

%PC3 loadings plotted over time
begrow = 380;
endrow = 328;
load3roll = [];
while endrow > 0
    [wcoeff,score,latent,tsquared,explained] = pca(totalret(endrow:begrow,:));
    begrow = begrow - 1;
    endrow = endrow - 1;
    load3roll = vertcat(load3roll,wcoeff(3));
end

%PC4 loadings plotted over time
begrow = 380;
endrow = 328;
load4roll = [];
while endrow > 0
    [wcoeff,score,latent,tsquared,explained] = pca(totalret(endrow:begrow,:));
    begrow = begrow - 1;
    endrow = endrow - 1;
    load4roll = vertcat(load4roll,wcoeff(4));
end

%correlation = xcorr(load1roll,load2roll);
%plot(t,load2roll,'DatetimeTickFormat','dd-mm-yyyy');

%This will be the final plot for loadings
%plot(t,[load1roll,load2roll,load3roll,load4roll]);

