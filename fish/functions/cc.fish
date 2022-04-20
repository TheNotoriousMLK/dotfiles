function cc --description 'Clears the cache and frees up RAM on WSL'
  if grep -iq microsoft /proc/version
    echo 3 | sudo tee /proc/sys/vm/drop_caches
  end
end
