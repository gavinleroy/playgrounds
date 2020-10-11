(get-info :version)
; (:version "4.8.6")
; Started: 2020-10-11 17:35:32
; Silicon.version: 1.1-SNAPSHOT (f48de7f6+@(detached))
; Input file: dummy.vpr
; Verifier id: 00
; ------------------------------------------------------------
; Begin preamble
; ////////// Static preamble
; 
; ; /z3config.smt2
(set-option :print-success true) ; Boogie: false
(set-option :global-decls true) ; Boogie: default
(set-option :auto_config false) ; Usually a good idea
(set-option :smt.restart_strategy 0)
(set-option :smt.restart_factor |1.5|)
(set-option :smt.case_split 3)
(set-option :smt.delay_units true)
(set-option :smt.delay_units_threshold 16)
(set-option :nnf.sk_hack true)
(set-option :type_check true)
(set-option :smt.bv.reflect true)
(set-option :smt.mbqi false)
(set-option :smt.qi.eager_threshold 100)
(set-option :smt.qi.cost "(+ weight generation)")
(set-option :smt.qi.max_multi_patterns 1000)
(set-option :smt.phase_selection 0) ; default: 3, Boogie: 0
(set-option :sat.phase caching)
(set-option :sat.random_seed 0)
(set-option :nlsat.randomize true)
(set-option :nlsat.seed 0)
(set-option :nlsat.shuffle_vars false)
(set-option :fp.spacer.order_children 0) ; Not available with Z3 4.5
(set-option :fp.spacer.random_seed 0) ; Not available with Z3 4.5
(set-option :smt.arith.random_initial_value true) ; Boogie: true
(set-option :smt.random_seed 0)
(set-option :sls.random_offset true)
(set-option :sls.random_seed 0)
(set-option :sls.restart_init false)
(set-option :sls.walksat_ucb true)
(set-option :model.v2 true)
; 
; ; /preamble.smt2
(declare-datatypes () ((
    $Snap ($Snap.unit)
    ($Snap.combine ($Snap.first $Snap) ($Snap.second $Snap)))))
(declare-sort $Ref 0)
(declare-const $Ref.null $Ref)
(declare-sort $FPM)
(declare-sort $PPM)
(define-sort $Perm () Real)
(define-const $Perm.Write $Perm 1.0)
(define-const $Perm.No $Perm 0.0)
(define-fun $Perm.isValidVar ((p $Perm)) Bool
	(<= $Perm.No p))
(define-fun $Perm.isReadVar ((p $Perm) (ub $Perm)) Bool
    (and ($Perm.isValidVar p)
         (not (= p $Perm.No))
         (< p $Perm.Write)))
(define-fun $Perm.min ((p1 $Perm) (p2 $Perm)) Real
    (ite (<= p1 p2) p1 p2))
(define-fun $Math.min ((a Int) (b Int)) Int
    (ite (<= a b) a b))
(define-fun $Math.clip ((a Int)) Int
    (ite (< a 0) 0 a))
; ////////// Sorts
(declare-sort $FVF<$Ref>)
; ////////// Sort wrappers
; Declaring additional sort wrappers
(declare-fun $SortWrappers.IntTo$Snap (Int) $Snap)
(declare-fun $SortWrappers.$SnapToInt ($Snap) Int)
(assert (forall ((x Int)) (!
    (= x ($SortWrappers.$SnapToInt($SortWrappers.IntTo$Snap x)))
    :pattern (($SortWrappers.IntTo$Snap x))
    :qid |$Snap.$SnapToIntTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.IntTo$Snap($SortWrappers.$SnapToInt x)))
    :pattern (($SortWrappers.$SnapToInt x))
    :qid |$Snap.IntTo$SnapToInt|
    )))
(declare-fun $SortWrappers.BoolTo$Snap (Bool) $Snap)
(declare-fun $SortWrappers.$SnapToBool ($Snap) Bool)
(assert (forall ((x Bool)) (!
    (= x ($SortWrappers.$SnapToBool($SortWrappers.BoolTo$Snap x)))
    :pattern (($SortWrappers.BoolTo$Snap x))
    :qid |$Snap.$SnapToBoolTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.BoolTo$Snap($SortWrappers.$SnapToBool x)))
    :pattern (($SortWrappers.$SnapToBool x))
    :qid |$Snap.BoolTo$SnapToBool|
    )))
(declare-fun $SortWrappers.$RefTo$Snap ($Ref) $Snap)
(declare-fun $SortWrappers.$SnapTo$Ref ($Snap) $Ref)
(assert (forall ((x $Ref)) (!
    (= x ($SortWrappers.$SnapTo$Ref($SortWrappers.$RefTo$Snap x)))
    :pattern (($SortWrappers.$RefTo$Snap x))
    :qid |$Snap.$SnapTo$RefTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$RefTo$Snap($SortWrappers.$SnapTo$Ref x)))
    :pattern (($SortWrappers.$SnapTo$Ref x))
    :qid |$Snap.$RefTo$SnapTo$Ref|
    )))
(declare-fun $SortWrappers.$PermTo$Snap ($Perm) $Snap)
(declare-fun $SortWrappers.$SnapTo$Perm ($Snap) $Perm)
(assert (forall ((x $Perm)) (!
    (= x ($SortWrappers.$SnapTo$Perm($SortWrappers.$PermTo$Snap x)))
    :pattern (($SortWrappers.$PermTo$Snap x))
    :qid |$Snap.$SnapTo$PermTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$PermTo$Snap($SortWrappers.$SnapTo$Perm x)))
    :pattern (($SortWrappers.$SnapTo$Perm x))
    :qid |$Snap.$PermTo$SnapTo$Perm|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.$FVF<$Ref>To$Snap ($FVF<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<$Ref> ($Snap) $FVF<$Ref>)
(assert (forall ((x $FVF<$Ref>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<$Ref>($SortWrappers.$FVF<$Ref>To$Snap x)))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<$Ref>To$Snap($SortWrappers.$SnapTo$FVF<$Ref> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<$Ref> x))
    :qid |$Snap.$FVF<$Ref>To$SnapTo$FVF<$Ref>|
    )))
; ////////// Symbols
; Declaring symbols related to program functions (from program analysis)
(declare-fun read$ ($Snap) $Perm)
(declare-fun read$%limited ($Snap) $Perm)
(declare-const read$%stateless Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun DeadBorrowToken$%trigger ($Snap Int) Bool)
(declare-fun array$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_$1%trigger ($Snap $Ref) Bool)
(declare-fun array$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$1%trigger ($Snap $Ref) Bool)
(declare-fun array$ref$str$2%trigger ($Snap $Ref) Bool)
(declare-fun char%trigger ($Snap $Ref) Bool)
(declare-fun i32%trigger ($Snap $Ref) Bool)
(declare-fun isize%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$alloc$opensqu$0$closesqu$$$Global$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$arc$opensqu$0$closesqu$$$Arc$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$arc$opensqu$0$closesqu$$$ArcInner$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$boxed$opensqu$0$closesqu$$$Box$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Custom$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$boxed$opensqu$0$closesqu$$$Box$opensqu$0$closesqu$$_beg_$m_std$$sys_common$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$raw_vec$opensqu$0$closesqu$$$RawVec$opensqu$0$closesqu$$_beg_$u8$_sep_$m_alloc$$alloc$opensqu$0$closesqu$$$Global$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$string$opensqu$0$closesqu$$$String$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_alloc$$vec$opensqu$0$closesqu$$$Vec$opensqu$0$closesqu$$_beg_$u8$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$m_libc$$unix$opensqu$0$closesqu$$$notbsd$opensqu$0$closesqu$$$linux$opensqu$0$closesqu$$$pthread_mutex_t$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$u8$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$usize$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$Arguments$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Alignment$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Count$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Count$opensqu$0$closesqu$$_beg_$_end_Is%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Count$opensqu$0$closesqu$$_beg_$_end_Param%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$FormatSpec$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Position$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Position$opensqu$0$closesqu$$_beg_$_end_At%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$marker$opensqu$0$closesqu$$$PhantomData$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$num$opensqu$0$closesqu$$$IntErrorKind$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$option$opensqu$0$closesqu$$$Option$opensqu$0$closesqu$$_beg_$ref$slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$option$opensqu$0$closesqu$$$Option$opensqu$0$closesqu$$_beg_$ref$slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$_end_Some%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$ptr$opensqu$0$closesqu$$$NonNull$opensqu$0$closesqu$$_beg_$m_alloc$$arc$opensqu$0$closesqu$$$ArcInner$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$ptr$opensqu$0$closesqu$$$Unique$opensqu$0$closesqu$$_beg_$u8$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_Err%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_Ok%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$usize$_sep_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$usize$_sep_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_$_end_Err%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$usize$_sep_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_$_end_Ok%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$sync$opensqu$0$closesqu$$$atomic$opensqu$0$closesqu$$$AtomicBool$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_core$$sync$opensqu$0$closesqu$$$atomic$opensqu$0$closesqu$$$AtomicUsize$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_libc$$unix$opensqu$0$closesqu$$$notbsd$opensqu$0$closesqu$$$linux$opensqu$0$closesqu$$$pthread_mutex_t$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Custom$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$ErrorKind$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_Custom%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_Os%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_Simple%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_Real%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Stdin$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$sys$opensqu$0$closesqu$$$unix$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$sys$opensqu$0$closesqu$$$unix$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Stdin$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$sys_common$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun m_std$$sys_common$opensqu$0$closesqu$$$poison$opensqu$0$closesqu$$$Flag$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun ref$array$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_$1%trigger ($Snap $Ref) Bool)
(declare-fun ref$array$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$1%trigger ($Snap $Ref) Bool)
(declare-fun ref$array$ref$str$2%trigger ($Snap $Ref) Bool)
(declare-fun ref$m_alloc$$string$opensqu$0$closesqu$$$String$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun ref$m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun ref$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Stdin$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun ref$ref$str%trigger ($Snap $Ref) Bool)
(declare-fun ref$slice$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun ref$slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun ref$slice$ref$str%trigger ($Snap $Ref) Bool)
(declare-fun ref$str%trigger ($Snap $Ref) Bool)
(declare-fun ref$tuple1$ref$ref$str%trigger ($Snap $Ref) Bool)
(declare-fun ref$tuple1$ref$u32%trigger ($Snap $Ref) Bool)
(declare-fun ref$u32%trigger ($Snap $Ref) Bool)
(declare-fun slice$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_%trigger ($Snap $Ref) Bool)
(declare-fun slice$ref$str%trigger ($Snap $Ref) Bool)
(declare-fun str%trigger ($Snap $Ref) Bool)
(declare-fun tuple0$%trigger ($Snap $Ref) Bool)
(declare-fun tuple1$ref$ref$str%trigger ($Snap $Ref) Bool)
(declare-fun tuple1$ref$u32%trigger ($Snap $Ref) Bool)
(declare-fun u32%trigger ($Snap $Ref) Bool)
(declare-fun u8%trigger ($Snap $Ref) Bool)
(declare-fun usize%trigger ($Snap $Ref) Bool)
; ////////// Uniqueness assumptions from domains
; ////////// Axioms
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ---------- FUNCTION read$----------
(declare-fun result@0@00 () $Perm)
; ----- Well-definedness of specifications -----
(push) ; 1
(declare-const $t@1@00 $Snap)
(assert (= $t@1@00 ($Snap.combine ($Snap.first $t@1@00) ($Snap.second $t@1@00))))
(assert (= ($Snap.first $t@1@00) $Snap.unit))
; [eval] none < result
(assert (< $Perm.No result@0@00))
(assert (= ($Snap.second $t@1@00) $Snap.unit))
; [eval] result < write
(assert (< result@0@00 $Perm.Write))
(pop) ; 1
(assert (forall ((s@$ $Snap)) (!
  (= (read$%limited s@$) (read$ s@$))
  :pattern ((read$ s@$))
  )))
(assert (forall ((s@$ $Snap)) (!
  (as read$%stateless  Bool)
  :pattern ((read$%limited s@$))
  )))
(assert (forall ((s@$ $Snap)) (!
  (let ((result@0@00 (read$%limited s@$))) (and
    (< $Perm.No result@0@00)
    (< result@0@00 $Perm.Write)))
  :pattern ((read$%limited s@$))
  )))
; ---------- DeadBorrowToken$ ----------
(declare-const borrow@2@00 Int)
; ---------- array$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_$1 ----------
(declare-const self@3@00 $Ref)
; ---------- array$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$1 ----------
(declare-const self@4@00 $Ref)
; ---------- array$ref$str$2 ----------
(declare-const self@5@00 $Ref)
; ---------- char ----------
(declare-const self@6@00 $Ref)
(push) ; 1
(declare-const $t@7@00 Int)
(assert (not (= self@6@00 $Ref.null)))
(pop) ; 1
; ---------- i32 ----------
(declare-const self@8@00 $Ref)
(push) ; 1
(declare-const $t@9@00 Int)
(assert (not (= self@8@00 $Ref.null)))
(pop) ; 1
; ---------- isize ----------
(declare-const self@10@00 $Ref)
(push) ; 1
(declare-const $t@11@00 Int)
(assert (not (= self@10@00 $Ref.null)))
(pop) ; 1
; ---------- m_alloc$$alloc$opensqu$0$closesqu$$$Global$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@12@00 $Ref)
(push) ; 1
(declare-const $t@13@00 $Snap)
(assert (= $t@13@00 $Snap.unit))
(pop) ; 1
; ---------- m_alloc$$arc$opensqu$0$closesqu$$$Arc$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_ ----------
(declare-const self@14@00 $Ref)
(push) ; 1
(declare-const $t@15@00 $Snap)
(assert (= $t@15@00 ($Snap.combine ($Snap.first $t@15@00) ($Snap.second $t@15@00))))
(assert (not (= self@14@00 $Ref.null)))
(assert (=
  ($Snap.second $t@15@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@15@00))
    ($Snap.second ($Snap.second $t@15@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@15@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@15@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@15@00))))))
(pop) ; 1
; ---------- m_alloc$$arc$opensqu$0$closesqu$$$ArcInner$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_ ----------
(declare-const self@16@00 $Ref)
(push) ; 1
(declare-const $t@17@00 $Snap)
(assert (= $t@17@00 ($Snap.combine ($Snap.first $t@17@00) ($Snap.second $t@17@00))))
(assert (not (= self@16@00 $Ref.null)))
(assert (=
  ($Snap.second $t@17@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@17@00))
    ($Snap.second ($Snap.second $t@17@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@17@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@17@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@17@00))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@17@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@00)))))))
(set-option :timeout 10)
(push) ; 2
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@17@00))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@17@00)))))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@00))))))))
(pop) ; 1
; ---------- m_alloc$$boxed$opensqu$0$closesqu$$$Box$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Custom$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@18@00 $Ref)
(push) ; 1
(declare-const $t@19@00 $Snap)
(assert (= $t@19@00 ($Snap.combine ($Snap.first $t@19@00) ($Snap.second $t@19@00))))
(assert (not (= self@18@00 $Ref.null)))
(pop) ; 1
; ---------- m_alloc$$boxed$opensqu$0$closesqu$$$Box$opensqu$0$closesqu$$_beg_$m_std$$sys_common$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@20@00 $Ref)
(push) ; 1
(declare-const $t@21@00 $Snap)
(assert (= $t@21@00 ($Snap.combine ($Snap.first $t@21@00) ($Snap.second $t@21@00))))
(assert (not (= self@20@00 $Ref.null)))
(pop) ; 1
; ---------- m_alloc$$raw_vec$opensqu$0$closesqu$$$RawVec$opensqu$0$closesqu$$_beg_$u8$_sep_$m_alloc$$alloc$opensqu$0$closesqu$$$Global$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@22@00 $Ref)
(push) ; 1
(declare-const $t@23@00 $Snap)
(assert (= $t@23@00 ($Snap.combine ($Snap.first $t@23@00) ($Snap.second $t@23@00))))
(assert (not (= self@22@00 $Ref.null)))
(assert (=
  ($Snap.second $t@23@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@23@00))
    ($Snap.second ($Snap.second $t@23@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@23@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@23@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@23@00))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@23@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@00))))))))
(pop) ; 1
; ---------- m_alloc$$string$opensqu$0$closesqu$$$String$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@24@00 $Ref)
(push) ; 1
(declare-const $t@25@00 $Snap)
(assert (= $t@25@00 ($Snap.combine ($Snap.first $t@25@00) ($Snap.second $t@25@00))))
(assert (not (= self@24@00 $Ref.null)))
(pop) ; 1
; ---------- m_alloc$$vec$opensqu$0$closesqu$$$Vec$opensqu$0$closesqu$$_beg_$u8$_end_ ----------
(declare-const self@26@00 $Ref)
(push) ; 1
(declare-const $t@27@00 $Snap)
(assert (= $t@27@00 ($Snap.combine ($Snap.first $t@27@00) ($Snap.second $t@27@00))))
(assert (not (= self@26@00 $Ref.null)))
(assert (=
  ($Snap.second $t@27@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@27@00))
    ($Snap.second ($Snap.second $t@27@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@27@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@27@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@27@00))))))
(pop) ; 1
; ---------- m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$m_libc$$unix$opensqu$0$closesqu$$$notbsd$opensqu$0$closesqu$$$linux$opensqu$0$closesqu$$$pthread_mutex_t$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@28@00 $Ref)
(push) ; 1
(declare-const $t@29@00 $Snap)
(assert (= $t@29@00 ($Snap.combine ($Snap.first $t@29@00) ($Snap.second $t@29@00))))
(assert (not (= self@28@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_ ----------
(declare-const self@30@00 $Ref)
(push) ; 1
(declare-const $t@31@00 $Snap)
(assert (= $t@31@00 ($Snap.combine ($Snap.first $t@31@00) ($Snap.second $t@31@00))))
(assert (not (= self@30@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$u8$_end_ ----------
(declare-const self@32@00 $Ref)
(push) ; 1
(declare-const $t@33@00 $Snap)
(assert (= $t@33@00 ($Snap.combine ($Snap.first $t@33@00) ($Snap.second $t@33@00))))
(assert (not (= self@32@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$cell$opensqu$0$closesqu$$$UnsafeCell$opensqu$0$closesqu$$_beg_$usize$_end_ ----------
(declare-const self@34@00 $Ref)
(push) ; 1
(declare-const $t@35@00 $Snap)
(assert (= $t@35@00 ($Snap.combine ($Snap.first $t@35@00) ($Snap.second $t@35@00))))
(assert (not (= self@34@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@36@00 $Ref)
; ---------- m_core$$fmt$opensqu$0$closesqu$$$Arguments$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@37@00 $Ref)
(push) ; 1
(declare-const $t@38@00 $Snap)
(assert (= $t@38@00 ($Snap.combine ($Snap.first $t@38@00) ($Snap.second $t@38@00))))
(assert (not (= self@37@00 $Ref.null)))
(assert (=
  ($Snap.second $t@38@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@38@00))
    ($Snap.second ($Snap.second $t@38@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@38@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@38@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@38@00))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@38@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@00))))))))
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Alignment$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@39@00 $Ref)
(push) ; 1
(declare-const $t@40@00 $Snap)
(assert (= $t@40@00 ($Snap.combine ($Snap.first $t@40@00) ($Snap.second $t@40@00))))
(assert (not (= self@39@00 $Ref.null)))
(assert (=
  ($Snap.second $t@40@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@40@00))
    ($Snap.second ($Snap.second $t@40@00)))))
(assert (= ($Snap.first ($Snap.second $t@40@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@40@00))))
(assert (= ($Snap.second ($Snap.second $t@40@00)) $Snap.unit))
; [eval] self.discriminant <= 3
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@40@00)) 3))
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@41@00 $Ref)
(push) ; 1
(declare-const $t@42@00 $Snap)
(assert (= $t@42@00 ($Snap.combine ($Snap.first $t@42@00) ($Snap.second $t@42@00))))
(assert (not (= self@41@00 $Ref.null)))
(assert (=
  ($Snap.second $t@42@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@42@00))
    ($Snap.second ($Snap.second $t@42@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@42@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@42@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@42@00))))))
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Count$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@43@00 $Ref)
(push) ; 1
(declare-const $t@44@00 $Snap)
(assert (= $t@44@00 ($Snap.combine ($Snap.first $t@44@00) ($Snap.second $t@44@00))))
(assert (not (= self@43@00 $Ref.null)))
(assert (=
  ($Snap.second $t@44@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@44@00))
    ($Snap.second ($Snap.second $t@44@00)))))
(assert (= ($Snap.first ($Snap.second $t@44@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@44@00))))
(assert (=
  ($Snap.second ($Snap.second $t@44@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@44@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@44@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@44@00))) $Snap.unit))
; [eval] self.discriminant <= 3
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 3))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@44@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@44@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00))))))))
; [eval] self.discriminant == 0
(push) ; 2
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 0))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 0)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 0 | First:($t@44@00) == 0 | live]
; [else-branch: 0 | First:($t@44@00) != 0 | live]
(push) ; 2
; [then-branch: 0 | First:($t@44@00) == 0]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00)))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 1))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 1 | First:($t@44@00) == 1 | dead]
; [else-branch: 1 | First:($t@44@00) != 1 | live]
(push) ; 3
; [else-branch: 1 | First:($t@44@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00))))))
  $Snap.unit))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 0 | First:($t@44@00) != 0]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 0)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00)))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 1))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 1)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 2 | First:($t@44@00) == 1 | live]
; [else-branch: 2 | First:($t@44@00) != 1 | live]
(push) ; 3
; [then-branch: 2 | First:($t@44@00) == 1]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 1))
(pop) ; 3
(push) ; 3
; [else-branch: 2 | First:($t@44@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@44@00)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@44@00))))))
  $Snap.unit))
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Count$opensqu$0$closesqu$$_beg_$_end_Is ----------
(declare-const self@45@00 $Ref)
(push) ; 1
(declare-const $t@46@00 $Snap)
(assert (= $t@46@00 ($Snap.combine ($Snap.first $t@46@00) ($Snap.second $t@46@00))))
(assert (not (= self@45@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Count$opensqu$0$closesqu$$_beg_$_end_Param ----------
(declare-const self@47@00 $Ref)
(push) ; 1
(declare-const $t@48@00 $Snap)
(assert (= $t@48@00 ($Snap.combine ($Snap.first $t@48@00) ($Snap.second $t@48@00))))
(assert (not (= self@47@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$FormatSpec$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@49@00 $Ref)
(push) ; 1
(declare-const $t@50@00 $Snap)
(assert (= $t@50@00 ($Snap.combine ($Snap.first $t@50@00) ($Snap.second $t@50@00))))
(assert (not (= self@49@00 $Ref.null)))
(assert (=
  ($Snap.second $t@50@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@50@00))
    ($Snap.second ($Snap.second $t@50@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@50@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@50@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@50@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@50@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))))))))
(push) ; 2
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@00)))))))))))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Position$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@51@00 $Ref)
(push) ; 1
(declare-const $t@52@00 $Snap)
(assert (= $t@52@00 ($Snap.combine ($Snap.first $t@52@00) ($Snap.second $t@52@00))))
(assert (not (= self@51@00 $Ref.null)))
(assert (=
  ($Snap.second $t@52@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@52@00))
    ($Snap.second ($Snap.second $t@52@00)))))
(assert (= ($Snap.first ($Snap.second $t@52@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@52@00))))
(assert (=
  ($Snap.second ($Snap.second $t@52@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@52@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@52@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@52@00))) $Snap.unit))
; [eval] self.discriminant <= 1
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@52@00)) 1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@52@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@52@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@00)))))))
; [eval] self.discriminant == 1
(push) ; 2
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@52@00)) 1))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@52@00)) 1)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 3 | First:($t@52@00) == 1 | live]
; [else-branch: 3 | First:($t@52@00) != 1 | live]
(push) ; 2
; [then-branch: 3 | First:($t@52@00) == 1]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@52@00)) 1))
(pop) ; 2
(push) ; 2
; [else-branch: 3 | First:($t@52@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@52@00)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@52@00))))
  $Snap.unit))
(pop) ; 2
(pop) ; 1
; ---------- m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Position$opensqu$0$closesqu$$_beg_$_end_At ----------
(declare-const self@53@00 $Ref)
(push) ; 1
(declare-const $t@54@00 $Snap)
(assert (= $t@54@00 ($Snap.combine ($Snap.first $t@54@00) ($Snap.second $t@54@00))))
(assert (not (= self@53@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$marker$opensqu$0$closesqu$$$PhantomData$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_ ----------
(declare-const self@55@00 $Ref)
(push) ; 1
(declare-const $t@56@00 $Snap)
(assert (= $t@56@00 $Snap.unit))
(pop) ; 1
; ---------- m_core$$num$opensqu$0$closesqu$$$IntErrorKind$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@57@00 $Ref)
(push) ; 1
(declare-const $t@58@00 $Snap)
(assert (= $t@58@00 ($Snap.combine ($Snap.first $t@58@00) ($Snap.second $t@58@00))))
(assert (not (= self@57@00 $Ref.null)))
(assert (=
  ($Snap.second $t@58@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@58@00))
    ($Snap.second ($Snap.second $t@58@00)))))
(assert (= ($Snap.first ($Snap.second $t@58@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@58@00))))
(assert (= ($Snap.second ($Snap.second $t@58@00)) $Snap.unit))
; [eval] self.discriminant <= 3
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@58@00)) 3))
(pop) ; 1
; ---------- m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@59@00 $Ref)
(push) ; 1
(declare-const $t@60@00 $Snap)
(assert (= $t@60@00 ($Snap.combine ($Snap.first $t@60@00) ($Snap.second $t@60@00))))
(assert (not (= self@59@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$option$opensqu$0$closesqu$$$Option$opensqu$0$closesqu$$_beg_$ref$slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@61@00 $Ref)
(push) ; 1
(declare-const $t@62@00 $Snap)
(assert (= $t@62@00 ($Snap.combine ($Snap.first $t@62@00) ($Snap.second $t@62@00))))
(assert (not (= self@61@00 $Ref.null)))
(assert (=
  ($Snap.second $t@62@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@62@00))
    ($Snap.second ($Snap.second $t@62@00)))))
(assert (= ($Snap.first ($Snap.second $t@62@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@62@00))))
(assert (=
  ($Snap.second ($Snap.second $t@62@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@62@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@62@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@62@00))) $Snap.unit))
; [eval] self.discriminant <= 1
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@62@00)) 1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@62@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@62@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@00)))))))
; [eval] self.discriminant == 1
(push) ; 2
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@62@00)) 1))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@62@00)) 1)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 4 | First:($t@62@00) == 1 | live]
; [else-branch: 4 | First:($t@62@00) != 1 | live]
(push) ; 2
; [then-branch: 4 | First:($t@62@00) == 1]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@62@00)) 1))
(pop) ; 2
(push) ; 2
; [else-branch: 4 | First:($t@62@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@62@00)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@62@00))))
  $Snap.unit))
(pop) ; 2
(pop) ; 1
; ---------- m_core$$option$opensqu$0$closesqu$$$Option$opensqu$0$closesqu$$_beg_$ref$slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$_end_Some ----------
(declare-const self@63@00 $Ref)
(push) ; 1
(declare-const $t@64@00 $Snap)
(assert (= $t@64@00 ($Snap.combine ($Snap.first $t@64@00) ($Snap.second $t@64@00))))
(assert (not (= self@63@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$ptr$opensqu$0$closesqu$$$NonNull$opensqu$0$closesqu$$_beg_$m_alloc$$arc$opensqu$0$closesqu$$$ArcInner$opensqu$0$closesqu$$_beg_$m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_$_end_$_end_ ----------
(declare-const self@65@00 $Ref)
; ---------- m_core$$ptr$opensqu$0$closesqu$$$Unique$opensqu$0$closesqu$$_beg_$u8$_end_ ----------
(declare-const self@66@00 $Ref)
; ---------- m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@67@00 $Ref)
(push) ; 1
(declare-const $t@68@00 $Snap)
(assert (= $t@68@00 ($Snap.combine ($Snap.first $t@68@00) ($Snap.second $t@68@00))))
(assert (not (= self@67@00 $Ref.null)))
(assert (=
  ($Snap.second $t@68@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@68@00))
    ($Snap.second ($Snap.second $t@68@00)))))
(assert (= ($Snap.first ($Snap.second $t@68@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@68@00))))
(assert (=
  ($Snap.second ($Snap.second $t@68@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@68@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@68@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@68@00))) $Snap.unit))
; [eval] self.discriminant <= 1
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@68@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@68@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00))))))))
; [eval] self.discriminant == 0
(push) ; 2
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 0))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 0)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 5 | First:($t@68@00) == 0 | live]
; [else-branch: 5 | First:($t@68@00) != 0 | live]
(push) ; 2
; [then-branch: 5 | First:($t@68@00) == 0]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00)))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 1))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 6 | First:($t@68@00) == 1 | dead]
; [else-branch: 6 | First:($t@68@00) != 1 | live]
(push) ; 3
; [else-branch: 6 | First:($t@68@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00))))))
  $Snap.unit))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 5 | First:($t@68@00) != 0]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 0)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@68@00)))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 1))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 1)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 7 | First:($t@68@00) == 1 | live]
; [else-branch: 7 | First:($t@68@00) != 1 | dead]
(push) ; 3
; [then-branch: 7 | First:($t@68@00) == 1]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@68@00)) 1))
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_Err ----------
(declare-const self@69@00 $Ref)
(push) ; 1
(declare-const $t@70@00 $Snap)
(assert (= $t@70@00 ($Snap.combine ($Snap.first $t@70@00) ($Snap.second $t@70@00))))
(assert (not (= self@69@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_Ok ----------
(declare-const self@71@00 $Ref)
(push) ; 1
(declare-const $t@72@00 $Snap)
(assert (= $t@72@00 ($Snap.combine ($Snap.first $t@72@00) ($Snap.second $t@72@00))))
(assert (not (= self@71@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$usize$_sep_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@73@00 $Ref)
(push) ; 1
(declare-const $t@74@00 $Snap)
(assert (= $t@74@00 ($Snap.combine ($Snap.first $t@74@00) ($Snap.second $t@74@00))))
(assert (not (= self@73@00 $Ref.null)))
(assert (=
  ($Snap.second $t@74@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@74@00))
    ($Snap.second ($Snap.second $t@74@00)))))
(assert (= ($Snap.first ($Snap.second $t@74@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@74@00))))
(assert (=
  ($Snap.second ($Snap.second $t@74@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@74@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@74@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@74@00))) $Snap.unit))
; [eval] self.discriminant <= 1
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@74@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00))))))))
; [eval] self.discriminant == 0
(push) ; 2
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 0))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 0)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 8 | First:($t@74@00) == 0 | live]
; [else-branch: 8 | First:($t@74@00) != 0 | live]
(push) ; 2
; [then-branch: 8 | First:($t@74@00) == 0]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00)))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 1))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 9 | First:($t@74@00) == 1 | dead]
; [else-branch: 9 | First:($t@74@00) != 1 | live]
(push) ; 3
; [else-branch: 9 | First:($t@74@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 1)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00))))))
  $Snap.unit))
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 8 | First:($t@74@00) != 0]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 0)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@00)))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 1))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 1)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 10 | First:($t@74@00) == 1 | live]
; [else-branch: 10 | First:($t@74@00) != 1 | dead]
(push) ; 3
; [then-branch: 10 | First:($t@74@00) == 1]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@74@00)) 1))
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$usize$_sep_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_$_end_Err ----------
(declare-const self@75@00 $Ref)
(push) ; 1
(declare-const $t@76@00 $Snap)
(assert (= $t@76@00 ($Snap.combine ($Snap.first $t@76@00) ($Snap.second $t@76@00))))
(assert (not (= self@75@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$usize$_sep_$m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_$_end_Ok ----------
(declare-const self@77@00 $Ref)
(push) ; 1
(declare-const $t@78@00 $Snap)
(assert (= $t@78@00 ($Snap.combine ($Snap.first $t@78@00) ($Snap.second $t@78@00))))
(assert (not (= self@77@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$sync$opensqu$0$closesqu$$$atomic$opensqu$0$closesqu$$$AtomicBool$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@79@00 $Ref)
(push) ; 1
(declare-const $t@80@00 $Snap)
(assert (= $t@80@00 ($Snap.combine ($Snap.first $t@80@00) ($Snap.second $t@80@00))))
(assert (not (= self@79@00 $Ref.null)))
(pop) ; 1
; ---------- m_core$$sync$opensqu$0$closesqu$$$atomic$opensqu$0$closesqu$$$AtomicUsize$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@81@00 $Ref)
(push) ; 1
(declare-const $t@82@00 $Snap)
(assert (= $t@82@00 ($Snap.combine ($Snap.first $t@82@00) ($Snap.second $t@82@00))))
(assert (not (= self@81@00 $Ref.null)))
(pop) ; 1
; ---------- m_libc$$unix$opensqu$0$closesqu$$$notbsd$opensqu$0$closesqu$$$linux$opensqu$0$closesqu$$$pthread_mutex_t$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@83@00 $Ref)
; ---------- m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_ ----------
(declare-const self@84@00 $Ref)
; ---------- m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Custom$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@85@00 $Ref)
; ---------- m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Error$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@86@00 $Ref)
(push) ; 1
(declare-const $t@87@00 $Snap)
(assert (= $t@87@00 ($Snap.combine ($Snap.first $t@87@00) ($Snap.second $t@87@00))))
(assert (not (= self@86@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$ErrorKind$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@88@00 $Ref)
(push) ; 1
(declare-const $t@89@00 $Snap)
(assert (= $t@89@00 ($Snap.combine ($Snap.first $t@89@00) ($Snap.second $t@89@00))))
(assert (not (= self@88@00 $Ref.null)))
(assert (=
  ($Snap.second $t@89@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@89@00))
    ($Snap.second ($Snap.second $t@89@00)))))
(assert (= ($Snap.first ($Snap.second $t@89@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@89@00))))
(assert (= ($Snap.second ($Snap.second $t@89@00)) $Snap.unit))
; [eval] self.discriminant <= 18
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@89@00)) 18))
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@90@00 $Ref)
(push) ; 1
(declare-const $t@91@00 $Snap)
(assert (= $t@91@00 ($Snap.combine ($Snap.first $t@91@00) ($Snap.second $t@91@00))))
(assert (not (= self@90@00 $Ref.null)))
(assert (=
  ($Snap.second $t@91@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@91@00))
    ($Snap.second ($Snap.second $t@91@00)))))
(assert (= ($Snap.first ($Snap.second $t@91@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@91@00))))
(assert (=
  ($Snap.second ($Snap.second $t@91@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@91@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@91@00))) $Snap.unit))
; [eval] self.discriminant <= 2
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@91@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@91@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))
; [eval] self.discriminant == 0
(push) ; 2
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 0))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 0)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 11 | First:($t@91@00) == 0 | live]
; [else-branch: 11 | First:($t@91@00) != 0 | live]
(push) ; 2
; [then-branch: 11 | First:($t@91@00) == 0]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 1))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 12 | First:($t@91@00) == 1 | dead]
; [else-branch: 12 | First:($t@91@00) != 1 | live]
(push) ; 3
; [else-branch: 12 | First:($t@91@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 1)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))))))
; [eval] self.discriminant == 2
(push) ; 4
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
; [then-branch: 13 | First:($t@91@00) == 2 | dead]
; [else-branch: 13 | First:($t@91@00) != 2 | live]
(push) ; 4
; [else-branch: 13 | First:($t@91@00) != 2]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))
  $Snap.unit))
(pop) ; 4
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 11 | First:($t@91@00) != 0]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 0)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))))
; [eval] self.discriminant == 1
(push) ; 3
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 1))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 1)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 14 | First:($t@91@00) == 1 | live]
; [else-branch: 14 | First:($t@91@00) != 1 | live]
(push) ; 3
; [then-branch: 14 | First:($t@91@00) == 1]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))))))
; [eval] self.discriminant == 2
(push) ; 4
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
; [then-branch: 15 | First:($t@91@00) == 2 | dead]
; [else-branch: 15 | First:($t@91@00) != 2 | live]
(push) ; 4
; [else-branch: 15 | First:($t@91@00) != 2]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))
  $Snap.unit))
(pop) ; 4
(pop) ; 3
(push) ; 3
; [else-branch: 14 | First:($t@91@00) != 1]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 1)))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@91@00)))))))))))
; [eval] self.discriminant == 2
(push) ; 4
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(push) ; 4
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
; [then-branch: 16 | First:($t@91@00) == 2 | live]
; [else-branch: 16 | First:($t@91@00) != 2 | dead]
(push) ; 4
; [then-branch: 16 | First:($t@91@00) == 2]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@91@00)) 2))
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_Custom ----------
(declare-const self@92@00 $Ref)
(push) ; 1
(declare-const $t@93@00 $Snap)
(assert (= $t@93@00 ($Snap.combine ($Snap.first $t@93@00) ($Snap.second $t@93@00))))
(assert (not (= self@92@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_Os ----------
(declare-const self@94@00 $Ref)
(push) ; 1
(declare-const $t@95@00 $Snap)
(assert (= $t@95@00 ($Snap.combine ($Snap.first $t@95@00) ($Snap.second $t@95@00))))
(assert (not (= self@94@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$error$opensqu$0$closesqu$$$Repr$opensqu$0$closesqu$$_beg_$_end_Simple ----------
(declare-const self@96@00 $Ref)
(push) ; 1
(declare-const $t@97@00 $Snap)
(assert (= $t@97@00 ($Snap.combine ($Snap.first $t@97@00) ($Snap.second $t@97@00))))
(assert (not (= self@96@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@98@00 $Ref)
(push) ; 1
(declare-const $t@99@00 $Snap)
(assert (= $t@99@00 ($Snap.combine ($Snap.first $t@99@00) ($Snap.second $t@99@00))))
(assert (not (= self@98@00 $Ref.null)))
(assert (=
  ($Snap.second $t@99@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@99@00))
    ($Snap.second ($Snap.second $t@99@00)))))
(assert (= ($Snap.first ($Snap.second $t@99@00)) $Snap.unit))
; [eval] 0 <= self.discriminant
(assert (<= 0 ($SortWrappers.$SnapToInt ($Snap.first $t@99@00))))
(assert (=
  ($Snap.second ($Snap.second $t@99@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@99@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@99@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@99@00))) $Snap.unit))
; [eval] self.discriminant <= 1
(assert (<= ($SortWrappers.$SnapToInt ($Snap.first $t@99@00)) 1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@99@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@99@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@99@00)))))))
; [eval] self.discriminant == 0
(push) ; 2
(assert (not (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@99@00)) 0))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@99@00)) 0)))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 17 | First:($t@99@00) == 0 | live]
; [else-branch: 17 | First:($t@99@00) != 0 | live]
(push) ; 2
; [then-branch: 17 | First:($t@99@00) == 0]
(assert (= ($SortWrappers.$SnapToInt ($Snap.first $t@99@00)) 0))
(pop) ; 2
(push) ; 2
; [else-branch: 17 | First:($t@99@00) != 0]
(assert (not (= ($SortWrappers.$SnapToInt ($Snap.first $t@99@00)) 0)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@99@00))))
  $Snap.unit))
(pop) ; 2
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_Real ----------
(declare-const self@100@00 $Ref)
(push) ; 1
(declare-const $t@101@00 $Snap)
(assert (= $t@101@00 ($Snap.combine ($Snap.first $t@101@00) ($Snap.second $t@101@00))))
(assert (not (= self@100@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Stdin$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@102@00 $Ref)
(push) ; 1
(declare-const $t@103@00 $Snap)
(assert (= $t@103@00 ($Snap.combine ($Snap.first $t@103@00) ($Snap.second $t@103@00))))
(assert (not (= self@102@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@104@00 $Ref)
(push) ; 1
(declare-const $t@105@00 $Snap)
(assert (= $t@105@00 ($Snap.combine ($Snap.first $t@105@00) ($Snap.second $t@105@00))))
(assert (not (= self@104@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$sync$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$buffered$opensqu$0$closesqu$$$BufReader$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Maybe$opensqu$0$closesqu$$_beg_$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$StdinRaw$opensqu$0$closesqu$$_beg_$_end_$_end_$_end_$_end_ ----------
(declare-const self@106@00 $Ref)
(push) ; 1
(declare-const $t@107@00 $Snap)
(assert (= $t@107@00 ($Snap.combine ($Snap.first $t@107@00) ($Snap.second $t@107@00))))
(assert (not (= self@106@00 $Ref.null)))
(assert (=
  ($Snap.second $t@107@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@107@00))
    ($Snap.second ($Snap.second $t@107@00)))))
(assert (=
  ($Snap.second ($Snap.second $t@107@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@107@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@107@00))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@107@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@107@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@107@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@107@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@107@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@107@00))))))))
(pop) ; 1
; ---------- m_std$$sys$opensqu$0$closesqu$$$unix$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@108@00 $Ref)
(push) ; 1
(declare-const $t@109@00 $Snap)
(assert (= $t@109@00 ($Snap.combine ($Snap.first $t@109@00) ($Snap.second $t@109@00))))
(assert (not (= self@108@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$sys$opensqu$0$closesqu$$$unix$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Stdin$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@110@00 $Ref)
(push) ; 1
(declare-const $t@111@00 $Snap)
(assert (= $t@111@00 ($Snap.combine ($Snap.first $t@111@00) ($Snap.second $t@111@00))))
(assert (not (= self@110@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$sys_common$opensqu$0$closesqu$$$mutex$opensqu$0$closesqu$$$Mutex$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@112@00 $Ref)
(push) ; 1
(declare-const $t@113@00 $Snap)
(assert (= $t@113@00 ($Snap.combine ($Snap.first $t@113@00) ($Snap.second $t@113@00))))
(assert (not (= self@112@00 $Ref.null)))
(pop) ; 1
; ---------- m_std$$sys_common$opensqu$0$closesqu$$$poison$opensqu$0$closesqu$$$Flag$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@114@00 $Ref)
(push) ; 1
(declare-const $t@115@00 $Snap)
(assert (= $t@115@00 ($Snap.combine ($Snap.first $t@115@00) ($Snap.second $t@115@00))))
(assert (not (= self@114@00 $Ref.null)))
(pop) ; 1
; ---------- ref$array$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_$1 ----------
(declare-const self@116@00 $Ref)
(push) ; 1
(declare-const $t@117@00 $Snap)
(assert (= $t@117@00 ($Snap.combine ($Snap.first $t@117@00) ($Snap.second $t@117@00))))
(assert (not (= self@116@00 $Ref.null)))
(pop) ; 1
; ---------- ref$array$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_$1 ----------
(declare-const self@118@00 $Ref)
(push) ; 1
(declare-const $t@119@00 $Snap)
(assert (= $t@119@00 ($Snap.combine ($Snap.first $t@119@00) ($Snap.second $t@119@00))))
(assert (not (= self@118@00 $Ref.null)))
(pop) ; 1
; ---------- ref$array$ref$str$2 ----------
(declare-const self@120@00 $Ref)
(push) ; 1
(declare-const $t@121@00 $Snap)
(assert (= $t@121@00 ($Snap.combine ($Snap.first $t@121@00) ($Snap.second $t@121@00))))
(assert (not (= self@120@00 $Ref.null)))
(pop) ; 1
; ---------- ref$m_alloc$$string$opensqu$0$closesqu$$$String$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@122@00 $Ref)
(push) ; 1
(declare-const $t@123@00 $Snap)
(assert (= $t@123@00 ($Snap.combine ($Snap.first $t@123@00) ($Snap.second $t@123@00))))
(assert (not (= self@122@00 $Ref.null)))
(pop) ; 1
; ---------- ref$m_core$$result$opensqu$0$closesqu$$$Result$opensqu$0$closesqu$$_beg_$u32$_sep_$m_core$$num$opensqu$0$closesqu$$$ParseIntError$opensqu$0$closesqu$$_beg_$_end_$_end_ ----------
(declare-const self@124@00 $Ref)
(push) ; 1
(declare-const $t@125@00 $Snap)
(assert (= $t@125@00 ($Snap.combine ($Snap.first $t@125@00) ($Snap.second $t@125@00))))
(assert (not (= self@124@00 $Ref.null)))
(pop) ; 1
; ---------- ref$m_std$$io$opensqu$0$closesqu$$$stdio$opensqu$0$closesqu$$$Stdin$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@126@00 $Ref)
(push) ; 1
(declare-const $t@127@00 $Snap)
(assert (= $t@127@00 ($Snap.combine ($Snap.first $t@127@00) ($Snap.second $t@127@00))))
(assert (not (= self@126@00 $Ref.null)))
(pop) ; 1
; ---------- ref$ref$str ----------
(declare-const self@128@00 $Ref)
(push) ; 1
(declare-const $t@129@00 $Snap)
(assert (= $t@129@00 ($Snap.combine ($Snap.first $t@129@00) ($Snap.second $t@129@00))))
(assert (not (= self@128@00 $Ref.null)))
(pop) ; 1
; ---------- ref$slice$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@130@00 $Ref)
(push) ; 1
(declare-const $t@131@00 $Snap)
(assert (= $t@131@00 ($Snap.combine ($Snap.first $t@131@00) ($Snap.second $t@131@00))))
(assert (not (= self@130@00 $Ref.null)))
(pop) ; 1
; ---------- ref$slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@132@00 $Ref)
(push) ; 1
(declare-const $t@133@00 $Snap)
(assert (= $t@133@00 ($Snap.combine ($Snap.first $t@133@00) ($Snap.second $t@133@00))))
(assert (not (= self@132@00 $Ref.null)))
(pop) ; 1
; ---------- ref$slice$ref$str ----------
(declare-const self@134@00 $Ref)
(push) ; 1
(declare-const $t@135@00 $Snap)
(assert (= $t@135@00 ($Snap.combine ($Snap.first $t@135@00) ($Snap.second $t@135@00))))
(assert (not (= self@134@00 $Ref.null)))
(pop) ; 1
; ---------- ref$str ----------
(declare-const self@136@00 $Ref)
(push) ; 1
(declare-const $t@137@00 $Snap)
(assert (= $t@137@00 ($Snap.combine ($Snap.first $t@137@00) ($Snap.second $t@137@00))))
(assert (not (= self@136@00 $Ref.null)))
(pop) ; 1
; ---------- ref$tuple1$ref$ref$str ----------
(declare-const self@138@00 $Ref)
(push) ; 1
(declare-const $t@139@00 $Snap)
(assert (= $t@139@00 ($Snap.combine ($Snap.first $t@139@00) ($Snap.second $t@139@00))))
(assert (not (= self@138@00 $Ref.null)))
(pop) ; 1
; ---------- ref$tuple1$ref$u32 ----------
(declare-const self@140@00 $Ref)
(push) ; 1
(declare-const $t@141@00 $Snap)
(assert (= $t@141@00 ($Snap.combine ($Snap.first $t@141@00) ($Snap.second $t@141@00))))
(assert (not (= self@140@00 $Ref.null)))
(pop) ; 1
; ---------- ref$u32 ----------
(declare-const self@142@00 $Ref)
(push) ; 1
(declare-const $t@143@00 $Snap)
(assert (= $t@143@00 ($Snap.combine ($Snap.first $t@143@00) ($Snap.second $t@143@00))))
(assert (not (= self@142@00 $Ref.null)))
(pop) ; 1
; ---------- slice$m_core$$fmt$opensqu$0$closesqu$$$ArgumentV1$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@144@00 $Ref)
; ---------- slice$m_core$$fmt$opensqu$0$closesqu$$$rt$opensqu$0$closesqu$$$v1$opensqu$0$closesqu$$$Argument$opensqu$0$closesqu$$_beg_$_end_ ----------
(declare-const self@145@00 $Ref)
; ---------- slice$ref$str ----------
(declare-const self@146@00 $Ref)
; ---------- str ----------
(declare-const self@147@00 $Ref)
; ---------- tuple0$ ----------
(declare-const self@148@00 $Ref)
(push) ; 1
(declare-const $t@149@00 $Snap)
(assert (= $t@149@00 $Snap.unit))
(pop) ; 1
; ---------- tuple1$ref$ref$str ----------
(declare-const self@150@00 $Ref)
(push) ; 1
(declare-const $t@151@00 $Snap)
(assert (= $t@151@00 ($Snap.combine ($Snap.first $t@151@00) ($Snap.second $t@151@00))))
(assert (not (= self@150@00 $Ref.null)))
(pop) ; 1
; ---------- tuple1$ref$u32 ----------
(declare-const self@152@00 $Ref)
(push) ; 1
(declare-const $t@153@00 $Snap)
(assert (= $t@153@00 ($Snap.combine ($Snap.first $t@153@00) ($Snap.second $t@153@00))))
(assert (not (= self@152@00 $Ref.null)))
(pop) ; 1
; ---------- u32 ----------
(declare-const self@154@00 $Ref)
(push) ; 1
(declare-const $t@155@00 Int)
(assert (not (= self@154@00 $Ref.null)))
(pop) ; 1
; ---------- u8 ----------
(declare-const self@156@00 $Ref)
(push) ; 1
(declare-const $t@157@00 Int)
(assert (not (= self@156@00 $Ref.null)))
(pop) ; 1
; ---------- usize ----------
(declare-const self@158@00 $Ref)
(push) ; 1
(declare-const $t@159@00 Int)
(assert (not (= self@158@00 $Ref.null)))
(pop) ; 1
