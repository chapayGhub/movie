data = sortrows(load('data/u.data'),1);
s = size(data);
Test = [];
Train = [];
for k=1:s(1)
    m = mod(k,20);
    if m == 0
        m=10;
    end
     
    if m==10
        Test = [Test; data(k,:)];
    else
        Train = [Train;data(k,:)];
   end
end
save user_rating data;
data = Test;
save user_rating_test data;
data = Train;
save user_rating_training data;
clear data;
clear Test;
clear Train;
clear s;
clear k;
clear m;