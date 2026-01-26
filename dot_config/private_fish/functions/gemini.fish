function gemini --wraps='npx @google/gemini-cli' --wraps='npx @google/gemini-cli --model gemini-3-pro-preview --yolo' --description 'alias gemini=npx @google/gemini-cli --model gemini-3-pro-preview --yolo'
    npx @google/gemini-cli --model gemini-3-pro-preview --yolo $argv
end
