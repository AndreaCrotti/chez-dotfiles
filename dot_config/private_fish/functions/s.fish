function s --wraps='sudo systemctl suspend' --description 'alias s sudo systemctl suspend'
  sudo systemctl suspend $argv
        
end
