a = csvread('usdcrosses.csv',1,1);
dates = csvread('usdcrosses.csv',1);
sizeA = size(a);

etf = importdata('ETFs.csv');

%This takes the first row and makes labels
cross = fopen('usdcrosses.csv');
c = textscan(cross,'%s',1);
test = c{1}{1};
fclose(cross);
toLabel = textscan(test,'%s',19,'Delimiter',',');
toLabel = toLabel{1};
Label = toLabel(2:19,:);
Label = cellstr(Label);
Labels = cellstr(Label); %These are the labels for the bi-plots

%cor = corr(a,a);
dates = dates(:,1);
crosses = cross(1,:);
[wcoeff,score,latent,tsquared,explained] = pca(a);

%loadings is the wcoeff or principal component coefficients
s = wcoeff;

x1 = s(:,1); %PC1
%y = s(:,2); %PC2
%z = s(:,3); %PC3
%q = s(:,4); %PC4

%bi-plot1
%ax = gca;
%scatter(x,y,'d','filled') %comparing PC1 and PC2 loadings
%ax.XAxisLocation = 'origin';
%text(x, y, Labels, 'horizontal','left', 'vertical','bottom');

%this loop sums the returns for each cross every 7 days
rows = 1;
num = 1;
rownum = 1;
rowval = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
totalret = [];
while rows < 2666;
    while num < 7;
        rowval = rowval + a(rownum,:);
        num = num + 1;
        rownum = rownum + 1;
    end
    %total returns by week
    totalret = vertcat(totalret,rowval);
    rowval = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    num = 1;
    rows = rows + 7;
end

coeff = pca(totalret);
q = coeff;
x = q(:,1);
y = q(:,2);
y1 = q(:,3);
y2 = q(:,4);
y3 = q(:,5);
%bi-plot1
%ax = gca;
%scatter(x,y,'d','filled') %comparing PC1 and PC2 loadings
%ax.XAxisLocation = 'origin';
%text(x, y, Labels, 'horizontal','left', 'vertical','bottom');


%This loop generates the values for proportion of variance explained by PC1
%over time based on a 52-week rolling window.
begrow = 380;
endrow = 328;
finexpl = [];
while endrow > 0
    [wcoeff,score,latent,tsquared,explained] = pca(totalret(endrow:begrow,:));
    begrow = begrow - 1;
    endrow = endrow - 1;
    finexpl = vertcat(finexpl,explained(1));
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

