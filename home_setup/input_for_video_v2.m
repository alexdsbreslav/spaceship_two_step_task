% This code is designed to compile the necessary information for the video coding
% application. It pulls from each of the MatLab structures to create an excel file
% that is used as an input to make coding of food choice easier.

% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function input_for_video_v2(subject_number)

  % ------------------------------------------------------------------------------
  % ------------------------------------------------------------------------------
  % ---- File specifications
  file_root = '/Users/alex/OneDrive - Duke University/1. Research Projects/1. Huettel/17.09_MDT/8. Raw Data/MatLab'; % for Alex's computer
  video_file_root = '/Users/alex/OneDrive - Duke University/1. Research Projects/1. Huettel/17.09_MDT/8. Raw Data/videos'; % for Alex's computer
  % file_root = '\Users\ads48\Documents\Projects\18.08.07_MDT\raw_data\matlab' % for the eye-tracker
  % video_file_root = '\Users\ads48\Documents\Projects\18.08.07_MDT\raw_data\videos' % for the eye-tracker
  sl = '/'; % for OSX
  % sl = '\'; % for Windows

  % ------------------------------------------------------------------------------
  % ------------------------------------------------------------------------------

% load all of the necessary structures
filename_subnum = pad(num2str(subject_number), 4, 'left', '0');
data_file_path = [file_root sl 'sub' filename_subnum];
load([data_file_path sl 'initialization_structure.mat']);
load([data_file_path sl 'food.mat']);
load([data_file_path sl 'money.mat']);

% number of trials/size of the array
trials_food = length(food_struct.reward_feedback_on);
trials_money = length(money_struct.reward_feedback_on);
num_trials = trials_food + trials_money;
video_coding_input = cell(num_trials, 12);

% subID
video_coding_input(:, 1) = num2cell(subject_number);

% create video folder
video_file_path = [video_file_root sl 'sub' filename_subnum];
[~, msg, ~] = mkdir(video_file_path);

% foods
video_coding_input(:,3) = cellstr(initialization_struct.food_sweet{1}(7:end-4)); %variable is sweet_[food name].jpg
video_coding_input(:,4) = cellstr(initialization_struct.food_salt{1}(6:end-4)); %variable is salt_[food name].jpg

% food location
video_coding_input(:,5) = num2cell(initialization_struct.sweet_loc_left);

% block index
video_coding_input([1:trials_money],6) = num2cell(money_struct.block - 1);
video_coding_input([trials_money + 1:num_trials],6) = num2cell(food_struct.block - 1);

%video link
video_coding_input([1:trials_money],2) = cellstr([video_file_path sl filename_subnum '_' num2str(money_struct.block - 1) '.mp4']);
video_coding_input([trials_money+1:num_trials],2) = cellstr([video_file_path sl filename_subnum '_' num2str(food_struct.block - 1) '.mp4']);

% block name
video_coding_input([1:trials_money],7) = {'Money'};
video_coding_input([trials_money+1:num_trials],7) = {'Food'};

% trial numbers
video_coding_input([1:trials_money],8) = num2cell(1:trials_money);
video_coding_input([trials_money+1:num_trials],8) = num2cell(1:trials_food);

% reward feedback on
int = floor(money_struct.reward_feedback_on);
fract = money_struct.reward_feedback_on - int;
frame = floor(fract*30);
frames_per_seconds = int * 30;
money_time_as_frame = frames_per_seconds + frame;

int = floor(food_struct.reward_feedback_on);
fract = food_struct.reward_feedback_on - int;
frame = floor(fract*30);
frames_per_seconds = int * 30;
food_time_as_frame = frames_per_seconds + frame;

video_coding_input([1:trials_money],9) = num2cell(money_time_as_frame);
video_coding_input([trials_money+1:num_trials],9) = num2cell(food_time_as_frame);

% feedback state
video_coding_input([1:trials_money],10) = num2cell(money_struct.state);
video_coding_input([trials_money+1:num_trials],10) = num2cell(food_struct.state);

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

color_map = containers.Map({'red', 'orange', 'yellow'}, {'blue', 'purple', 'green'});
cool_color{1} = color_map(warm_color{1});
cool_color{2} = color_map(warm_color{2});

if strcmp(initialization_struct.stim_step2_color_select{1}, 'warm')
      block1_color_map = containers.Map({2,3}, {warm_color{1}, cool_color{1}});
      block2_color_map = containers.Map({2,3}, {warm_color{2}, cool_color{2}});
else
      block1_color_map = containers.Map({3,2}, {warm_color{1}, cool_color{1}});
      block2_color_map = containers.Map({3,2}, {warm_color{2}, cool_color{2}});
end

for idx = 1:trials_money
      video_coding_input{idx, 11} = block1_color_map(money_struct.state(idx));
end

for idx = trials_money+1:num_trials
      video_coding_input{idx, 11} = block2_color_map(food_struct.state(idx - trials_money));
end

% trial win
video_coding_input([1:trials_money],12) = num2cell(nansum(money_struct.payoff, 2));
video_coding_input([trials_money+1:num_trials],12) = num2cell(nansum(food_struct.payoff,2));

% convert array to table
T = table(video_coding_input(:,1), video_coding_input(:,2), video_coding_input(:,3), video_coding_input(:,4), video_coding_input(:,5), video_coding_input(:,6), video_coding_input(:,7), video_coding_input(:,8), video_coding_input(:,9), video_coding_input(:,10), video_coding_input(:,11), video_coding_input(:,12), ...
'VariableNames', {'subID', 'video_link', 'food_text_sweet', 'food_text_salt', 'sweet_loc_left', 'block_index', 'block_name', 'trial_num', 'reward_feedback_on', 'feedback_state', 'feedback_state_color', 'trial_win'});

% print table to excel
writetable(T, [video_file_path sl 'coding_input.xlsx']);


end
