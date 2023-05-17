{;; :portal {:dependencies [[djblue/portal "0.35.1"]]}
 ;; :dev {
 ;;       :dependencies [[com.github.flow-storm/clojure "RELEASE"]
 ;;                      [com.github.flow-storm/flow-storm-dbg "RELEASE"]
 ;;                      [djblue/portal "0.35.1"]]
 ;;       ;; for disabling the official compiler
 ;;       :exclusions [org.clojure/clojure]
 ;;       :jvm-opts ["-Dclojure.storm.instrumentEnable=true"
 ;;                  ]}}
 :user {:jvm-opts ["-Djdk.attach.allowAttachSelf"]
        :plugins [[lein-ancient "1.0.0-RC3"]
                  [lein-kibit "0.1.8"]]
        :injections [(require 'spyscope.core)
                     (require 'hashp.core)
                     (require 'sc.api)]
        :dependencies [[djblue/portal "0.35.1"]
                       ;; comment this out since it might be a bit much
                       ;; [org.scicloj/clay "2-beta8"]
                       [lambdaisland/kaocha "1.87.1366"]
                       [io.github.tonsky/clj-reload "0.7.0"]
                       [hashp "0.2.2"]
                       [com.lambdaisland/classpath "0.4.44"]
                       [lein-ancient "1.0.0-RC3"]
                       [vvvvalvalval/scope-capture "0.3.3"]
                       #_[com.github.mhjort/trombi "1.0.1"]
                       [com.taoensso/tufte "2.6.3"]
                       [com.clojure-goes-fast/clj-async-profiler "1.2.2"]
                       #_[ejc-sql "0.4.1-SNAPSHOT"]
                       [spyscope "0.1.6"]]}}
