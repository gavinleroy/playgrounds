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
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
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
; End function- and predicate-related preamble
; ------------------------------------------------------------
