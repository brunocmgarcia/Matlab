function s180213_keyDownListener(hObj,eventdata)
       key= eventdata.Key;
       if strcmpi(key,'leftarrow')
           currentxlim=xlim;
           xlim(currentxlim-5);
       elseif strcmpi(key,'rightarrow')
           currentxlim=xlim;
           xlim(currentxlim+5);
    
       end
       
    end