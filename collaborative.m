function [rec_list] = collaborative()

    close all;
    %content of data: user_id|movie_id|rating|timestamp
    %sorted by user_id
    data = load('user_rating.mat');
    data = data.data;
    %the number of the users
    no_user = max(data(:,1));
    %the number of the movies
    no_movie = max(data(:,2));
    
    %the distance between different users obtained by adopting equation R(x,y)
    %content of Rating: Rating(x,y) = distance between x and y
    Rating = zeros(no_user,no_user);
    
    %thres_pos: threshold of strong correlation between different users
    %thres_neg: threshold of loose correlation between different users
    thres_pos = 0.4;
    thres_neg = -0.5;
    %threshold of whether user likes the movie or not
    rec = 4;
    disrec = 3;
    %positive and negative counter of all the movies for each different user
    counter_pos = zeros(no_user,no_movie);
    counter_neg = zeros(no_user,no_movie);
    
    
    %mean of ratings of a certain user over all the movies watched beofre
    %content of rating_mean: mean of ratings|start row of this user|end row of this user
    %initialize rating_mean: function initialRatingMean
    rating_mean = initialRatingMean(data, no_user);

    
    for user_x = 1 : no_user%need to be changed to no_user
        %ux_film contains all the movies of user_x sorted by movie_id
        ux_film = sortrows(data(rating_mean(user_x,2):rating_mean(user_x,3),:),2);
        for user_y = 1 : no_user%need to be changed to no_user
            %uy_film contains all the movies of user_y sorted by movie_id
            uy_film = sortrows(data(rating_mean(user_y,2):rating_mean(user_y,3),:),2);
            Rating(user_x, user_y) = getRating(ux_film,uy_film,rating_mean,user_x,user_y,no_movie);
            [counter_pos, counter_neg] = initialCounter(counter_pos,counter_neg,Rating(user_x,user_y),thres_pos,thres_neg,rec,disrec,user_x,uy_film);
        end
    end
    
    
    %recommendation
    k = 0.5;
    thres = 40;
    rec_list = recommend(counter_pos,counter_neg,k,thres);
    save coll_recommend_list rec_list;
    clear rec_list;
    
end

%compute the positive and negative counters of movies 
function [c_pos,c_neg] = initialCounter(c_pos,c_neg,rating,thres_pos,thres_neg,rec,disrec,user_x,uy_film)
    if(rating > thres_pos) && ~(rating == 1)
        for counter_y = 1 : size(uy_film,1)
            if (uy_film(counter_y,3) >= rec)
                c_pos(user_x,uy_film(counter_y,2)) = c_pos(user_x,uy_film(counter_y,2)) + 1;
            elseif (uy_film(counter_y,3) <= disrec)
                c_neg(user_x,uy_film(counter_y,2)) = c_neg(user_x,uy_film(counter_y,2)) - 1;
            end
        end
    elseif(rating < thres_neg)
        for counter_y = 1 : size(uy_film,1);
            if(uy_film(counter_y,3) >= rec)
                c_neg(user_x,uy_film(counter_y,2)) = c_neg(user_x,uy_film(counter_y,2)) - 1;
            elseif(uy_film(counter_y,3) <= disrec)
                c_pos(user_x,uy_film(counter_y,2)) = c_pos(user_x,uy_film(counter_y,2)) + 1;
            end
        end
    end
end

%compute the R(x,y)
function [rating] = getRating(ux_film,uy_film,rating_mean,user_x,user_y,no_movie)
    Rxy_numerator = 0;
    Rxy_denominator_1 = 0;
    Rxy_denominator_2 = 0;
    for film = 1 : no_movie
        a = find(ux_film(:,2) == film);
        b = find(uy_film(:,2) == film);
        if ~isempty(a) && ~isempty(b)
            Rx = ux_film(a,3);
            Ry = uy_film(b,3);
            Rxy_numerator = Rxy_numerator + (Rx - rating_mean(user_x,1))*(Ry - rating_mean(user_y,1));
            Rxy_denominator_1 = Rxy_denominator_1 + (Rx - rating_mean(user_x,1))^2;
            Rxy_denominator_2 = Rxy_denominator_2 + (Ry - rating_mean(user_y,1))^2;
        end
    end
    rating = Rxy_numerator/sqrt(Rxy_denominator_1 * Rxy_denominator_2);
end

%compute the mean of the raitng of one particular user seperately.
function [rating_mean] = initialRatingMean(data,no_user)
    rating_mean = zeros(no_user,3);
    for i = 1: no_user
        j = find(data(:,1) == i);
        rating_mean(i,1) = mean(data(j(1,:):j(size(j,1),:),3));
        rating_mean(i,2) = j(1,:);
        rating_mean(i,3) = j(size(j,1),:);
    end
end


function [rec_list] = recommend(counter_pos,counter_neg,k,thres)
    %counter = zeros(size(counter_pos,1),size(counter_pos,2));
    
    counter = counter_pos + counter_neg.*k;
    pointer = 1;
    rec_list = [];
    for i = 1:size(counter_pos,1)
        for j = 1:size(counter_pos,2)
            if counter(i,j) > thres
                rec_list(pointer,:) = [i,counter_pos(i,j),counter(i,j)];
                pointer = pointer + 1;
            end
        end
    end
end