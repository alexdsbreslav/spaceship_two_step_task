% This code is designed to compile the necessary information for the video coding
% application. It pulls from each of the MatLab structures to create an excel file
% that is used as an input to make coding of food choice easier.

% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function compile_input_for_video_coding(subject_number)

  % ------------------------------------------------------------------------------
  % ------------------------------------------------------------------------------
  % ---- File specifications
  file_root = '/Users/alex/OneDrive - Duke University/1. Research Projects/1. Huettel/17.09_MDT/6. Raw Data/MatLab' % for Alex's computer
  video_file_root = '/Users/alex/OneDrive - Duke University/1. Research Projects/1. Huettel/17.09_MDT/6. Raw Data/Videos' % for Alex's computer
  % file_root = '\Users\ads48\Documents\Projects\18.08.07_MDT\raw_data\matlab' % for the eye-tracker
  % video_file_root = '\Users\ads48\Documents\Projects\18.08.07_MDT\raw_data\videos' % for the eye-tracker
  sl = '/'; % for OSX
  % sl = '\'; % for Windows

  % ------------------------------------------------------------------------------
  % ------------------------------------------------------------------------------

start_time_vid1 = input(['\n\n' ...
'We need the time stamp for the FIRST video.' '\n' ...
  'Record when the first frame occurs after the initializing camera... screen.' '\n' ...
  'Please enter the start time as a vector.' '\n' ...
  'e.g. [minutes, seconds, frames]' '\n' ...
  'Response (1st video): ' ]);

start_time_vid2 = input(['\n\n' ...
'We need the time stamp for the SECOND video.' '\n' ...
  'Record when the first frame occurs after the initializing camera... screen.' '\n' ...
  'Please enter the start time as a vector.' '\n' ...
  'e.g. [minutes, seconds, frames]' '\n' ...
  'Response (2nd video): ' ]);

start_time_vid1_frames = start_time_vid1(1)*60*30 + start_time_vid1(2)*30 + start_time_vid1(3);
start_time_vid2_frames = start_time_vid2(1)*60*30 + start_time_vid2(2)*30 + start_time_vid2(3);

% load all of the necessary structures
filename_subnum = pad(num2str(subject_number), 3, 'left', '0');
data_file_path = [file_root sl 'sub' filename_subnum];
load([data_file_path sl 'initialization structure.mat']);
load([data_file_path sl 'food.mat']);
load([data_file_path sl 'money.mat']);

% number of trials/size of the array
trials_food = length(food_struct.reward_feedback_on);
trials_money = length(money_struct.reward_feedback_on);
num_trials = trials_food + trials_money;
video_coding_input = cell(num_trials, 12);

% subID
video_coding_input(:, 1) = num2cell(subject_number);

% video link
video_file_path = [video_file_root sl 'sub' filename_subnum];
[~, msg, ~] = mkdir(video_file_path);
video_coding_input(:,2) = cellstr([video_file_path sl 'video.mp4']);

% foods
video_coding_input(:,3) = cellstr(initialization_struct.food_sweet{1}(7:end-4)); %variable is sweet_[food name].jpg
video_coding_input(:,4) = cellstr(initialization_struct.food_salt{1}(6:end-4)); %variable is salt_[food name].jpg

% food location
video_coding_input(:,5) = num2cell(initialization_struct.sweet_loc_left);

if initialization_struct.block(2) == 1
    money_start = 1;
    money_end = trials_money;
    food_start = trials_money + 1;
    food_end = num_trials;
else
    money_start = trials_food + 1;
    money_end = num_trials;
    food_start = 1;
    food_end = trials_food;
end

% block number
video_coding_input([money_start:money_end],6) = {2};
video_coding_input([food_start:food_end],6) = {3};

% block text
video_coding_input([money_start:money_end],7) = {'Money'};
video_coding_input([food_start:food_end],7) = {'Food'};

% trial numbers
video_coding_input([money_start:money_end],8) = num2cell(money_start:money_end);
video_coding_input([food_start:food_end],8) = num2cell(food_start:food_end);

% reward feedback on
if money_start == 1
    video_coding_input([money_start:money_end],9) = num2cell(floor(money_struct.reward_feedback_on*30)-2 + start_time_vid1_frames); % multiplying the seconds by fps. I am then subtracting 2 to make sure we undershoot the actual start
    video_coding_input([food_start:food_end],9) = num2cell(floor(food_struct.reward_feedback_on*30)-2 + start_time_vid2_frames);
else
    video_coding_input([money_start:money_end],9) = num2cell(floor(money_struct.reward_feedback_on*30)-2 + start_time_vid2_frames); % multiplying the seconds by fps. I am then subtracting 2 to make sure we undershoot the actual start
    video_coding_input([food_start:food_end],9) = num2cell(floor(food_struct.reward_feedback_on*30)-2 + start_time_vid1_frames);
end

% feedback state
video_coding_input([money_start:money_end],10) = num2cell(money_struct.state);
video_coding_input([food_start:food_end],10) = num2cell(food_struct.state);

% feedback state color
colors = {'red', 'orange', 'yellow'};

for block = 2:3
    step2_colors = initialization_struct.stim_colors_step2(block);
    num = 1;
    for color = colors
        a = contains(step2_colors, color);
        color_logical(num) = a;
        num = num + 1;
    end

    warm_color(block - 1) = colors(color_logical);
end

color_map = containers.Map({'red', 'orange', 'yellow'}, {'blue', 'purple', 'yellow'});
cool_color{1} = color_map(warm_color{1});
cool_color{2} = color_map(warm_color{2});

if strcmp(initialization_struct.stim_step2_color_select{1}, 'warm')
      block1_color_map = containers.Map({2,3}, {warm_color{1}, cool_color{1}});
      block2_color_map = containers.Map({2,3}, {warm_color{2}, cool_color{2}});
else
      block1_color_map = containers.Map({3,2}, {warm_color{1}, cool_color{1}});
      block2_color_map = containers.Map({3,2}, {warm_color{2}, cool_color{2}});
end

if money_start == 1
    for idx = money_start:money_end
          video_coding_input{idx, 11} = block1_color_map(money_struct.state(idx));
    end

    for idx = food_start:food_end
          video_coding_input{idx, 11} = block2_color_map(food_struct.state(idx - money_end));
    end
else
    for idx = money_start:money_end
          video_coding_input{idx, 11} = block2_color_map(money_struct.state(idx - food_end));
    end

    for idx = food_start:food_end
          video_coding_input{idx, 11} = block1_color_map(food_struct.state(idx));
    end
end

% trial win
video_coding_input([money_start:money_end],12) = num2cell(money_struct.payoff(~isnan(money_struct.payoff)));
video_coding_input([food_start:food_end],12) = num2cell(food_struct.payoff(~isnan(food_struct.payoff)));

% convert array to table
T = table(video_coding_input(:,1), video_coding_input(:,2), video_coding_input(:,3), video_coding_input(:,4), video_coding_input(:,5), video_coding_input(:,6), video_coding_input(:,7), video_coding_input(:,8), video_coding_input(:,9), video_coding_input(:,10), video_coding_input(:,11), video_coding_input(:,12), ...
'VariableNames', {'subID', 'video_link', 'food_text_sweet', 'food_text_salt', 'sweet_loc_left', 'block_num', 'block_text', 'trial_num', 'reward_feedback_on', 'feedback_state', 'feedback_state_color', 'trial_win'});

% print table to excel
writetable(T, [video_file_path sl 'coding_input.xlsx']);


end
