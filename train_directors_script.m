director= load('movie_info_data/DirectorMatrix.txt');

rating = load('user_rating_training.mat');
rating = rating.data;

errors = [];

users = max(rating(:,1));
for user = 1:users
index = find(rating(:,1) == user);
if isempty(index)
    continue;
end
input = [];
output = [];
for i=1:length(index)
    line = rating(i,:);
    movie = line(2);
    rate = line(3);
    type = director(find(director(:,1)==movie),2:end);
    input = [input;type];
    output = [output;rate];
end

net = trainNeronNet(input',output');
file = ['networks/net_director_',num2str(user)];

save(file,'net');
end


%{ 
testing = load('user_rating_test.mat');
testing = testing.data;
index = find(testing(:,1) == user);
input = [];
output = [];
for i=1:length(index)
line = testing(i,:);
movie = line(2);
rate = line(3);
      
d = director(find(types(:,1)==movie),2:end);
input = [input;d];
output = [output;rate];
end
y = sim(net,input')';

[a,b,c,d,e] = get_errors(output,y);
errors = [errors;[a,b,c,d,e]];
end

ll = sum(errors(:,1))
dd = sum(errors(:,2))
ld = sum(errors(:,3))
dl = sum(errors(:,4))
rate = mean(errors(:,5))
%}
