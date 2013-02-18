function [ y ] = user_similarity(ocupation_matrix)

users = load('movie_info_data/user.txt');

s = size(users);
y = zeros(s(1),s(1));

age_factor = 1;
gender_factor = 1;
occupation_factor = 1;
for i=1:s(1)
    for j=1:s(1)
        line1 = users(i,:);
        line2 = users(j,:);
        age_distance = 1-abs((line1(2)-line2(2))/100);
        gender_distance = 1-abs(line1(3)-line2(3));
        occupation_distance = 1-abs(ocupation_matrix(line1(4),line2(4))/4);
        y(i,j) = age_factor*age_distance+gender_factor*gender_distance+occupation_factor*occupation_distance;
    end
end

end

