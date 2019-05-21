function [click, x, y] = test(input_source)
        % ---- capture useful key clicks
        KbQueueCreate(1);
        KbQueueStart(input_source);
        useable_click = 0;
        while useable_click == 0 %wait for click inside designated area
          pressed = KbQueueCheck(input_source);
          if pressed %if touched
              [x, y, ~] = GetMouse(); %get touch location
              if (x >= 540) %click inside chosen box
                  useable_click = 1;
                  selection = 1;
              elseif (x < 540)
                  useable_click = 1;
                  selection = 2;
              end %click inside chosen box
          end %if touched
        end %click inside a designated area

        KbQueueStop(input_source);
        KbQueueFlush(input_source);

        click = selection;
end