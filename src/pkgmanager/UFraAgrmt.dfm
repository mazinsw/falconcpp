object FraAgrmt: TFraAgrmt
  Left = 0
  Top = 0
  Width = 498
  Height = 240
  TabOrder = 0
  object PainelAll: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label5: TLabel
      Left = 24
      Top = 16
      Width = 241
      Height = 13
      Caption = 'Press Page Down to see the rest of the agreement.'
    end
    object TextAnswer: TLabel
      Left = 24
      Top = 200
      Width = 449
      Height = 29
      AutoSize = False
      Caption = 
        'If you accept the terms of the agreement, click I Agree to conti' +
        'nue. You must accept the agreement to install %s.'
      WordWrap = True
    end
    object TextLicense: TRichEditViewer
      Left = 24
      Top = 40
      Width = 449
      Height = 153
      Lines.Strings = (
        '                    GNU GENERAL PUBLIC LICENSE   '#13
        '                       Version 3, 29 June 2007'#13
        '   '#13
        
          ' Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.o' +
          'rg/>'#13
        
          ' Everyone is permitted to copy and distribute verbatim copies   ' +
          #13
        ' of this license document, but changing it is not allowed.'#13
        '   '#13
        '                            Preamble'#13
        '   '#13
        
          '  The GNU General Public License is a free, copyleft license for' +
          #13
        'software and other kinds of works.   '#13
        #13
        
          '  The licenses for most software and other practical works are d' +
          'esigned   '#13
        
          'to take away your freedom to share and change the works.  By con' +
          'trast,'#13
        
          'the GNU General Public License is intended to guarantee your fre' +
          'edom to   '#13
        
          'share and change all versions of a program--to make sure it rema' +
          'ins free'#13
        
          'software for all its users.  We, the Free Software Foundation, u' +
          'se the   '#13
        
          'GNU General Public License for most of our software; it applies ' +
          'also to'#13
        
          'any other work released this way by its authors.  You can apply ' +
          'it to   '#13
        'your programs, too.'#13
        '   '#13
        
          '  When we speak of free software, we are referring to freedom, n' +
          'ot'#13
        
          'price.  Our General Public Licenses are designed to make sure th' +
          'at you   '#13
        
          'have the freedom to distribute copies of free software (and char' +
          'ge for'#13
        
          'them if you wish), that you receive source code or can get it if' +
          ' you   '#13
        
          'want it, that you can change the software or use pieces of it in' +
          ' new'#13
        'free programs, and that you know you can do these things.   '#13
        #13
        
          '  To protect your rights, we need to prevent others from denying' +
          ' you   '#13
        
          'these rights or asking you to surrender the rights.  Therefore, ' +
          'you have'#13
        
          'certain responsibilities if you distribute copies of the softwar' +
          'e, or if   '#13
        
          'you modify it: responsibilities to respect the freedom of others' +
          '.'#13
        '   '#13
        
          '  For example, if you distribute copies of such a program, wheth' +
          'er'#13
        
          'gratis or for a fee, you must pass on to the recipients the same' +
          '   '#13
        
          'freedoms that you received.  You must make sure that they, too, ' +
          'receive'#13
        
          'or can get the source code.  And you must show them these terms ' +
          'so they   '#13
        'know their rights.'#13
        '   '#13
        
          '  Developers that use the GNU GPL protect your rights with two s' +
          'teps:'#13
        
          '(1) assert copyright on the software, and (2) offer you this Lic' +
          'ense   '#13
        
          'giving you legal permission to copy, distribute and/or modify it' +
          '.'#13
        '   '#13
        
          '  For the developers'#39' and authors'#39' protection, the GPL clearly e' +
          'xplains'#13
        
          'that there is no warranty for this free software.  For both user' +
          's'#39' and   '#13
        
          'authors'#39' sake, the GPL requires that modified versions be marked' +
          ' as'#13
        
          'changed, so that their problems will not be attributed erroneous' +
          'ly to   '#13
        'authors of previous versions.'#13
        '   '#13
        
          '  Some devices are designed to deny users access to install or r' +
          'un'#13
        
          'modified versions of the software inside them, although the manu' +
          'facturer   '#13
        'can do so.  This is fundamentally incompatible with the aim of'#13
        
          'protecting users'#39' freedom to change the software.  The systemati' +
          'c   '#13
        
          'pattern of such abuse occurs in the area of products for individ' +
          'uals to'#13
        
          'use, which is precisely where it is most unacceptable.  Therefor' +
          'e, we   '#13
        
          'have designed this version of the GPL to prohibit the practice f' +
          'or those'#13
        
          'products.  If such problems arise substantially in other domains' +
          ', we   '#13
        
          'stand ready to extend this provision to those domains in future ' +
          'versions'#13
        'of the GPL, as needed to protect the freedom of users.   '#13
        #13
        
          '  Finally, every program is threatened constantly by software pa' +
          'tents.   '#13
        
          'States should not allow patents to restrict development and use ' +
          'of'#13
        
          'software on general-purpose computers, but in those that do, we ' +
          'wish to   '#13
        
          'avoid the special danger that patents applied to a free program ' +
          'could'#13
        
          'make it effectively proprietary.  To prevent this, the GPL assur' +
          'es that   '#13
        'patents cannot be used to render the program non-free.'#13
        '   '#13
        
          '  The precise terms and conditions for copying, distribution and' +
          #13
        'modification follow.   '#13
        #13
        '                       TERMS AND CONDITIONS   '#13
        #13
        '  0. Definitions.   '#13
        #13
        
          '  "This License" refers to version 3 of the GNU General Public L' +
          'icense.   '#13
        #13
        
          '  "Copyright" also means copyright-like laws that apply to other' +
          ' kinds of   '#13
        'works, such as semiconductor masks.'#13
        '   '#13
        
          '  "The Program" refers to any copyrightable work licensed under ' +
          'this'#13
        
          'License.  Each licensee is addressed as "you".  "Licensees" and ' +
          '  '#13
        '"recipients" may be individuals or organizations.'#13
        '   '#13
        
          '  To "modify" a work means to copy from or adapt all or part of ' +
          'the work'#13
        
          'in a fashion requiring copyright permission, other than the maki' +
          'ng of an   '#13
        
          'exact copy.  The resulting work is called a "modified version" o' +
          'f the'#13
        'earlier work or a work "based on" the earlier work.   '#13
        #13
        
          '  A "covered work" means either the unmodified Program or a work' +
          ' based   '#13
        'on the Program.'#13
        '   '#13
        
          '  To "propagate" a work means to do anything with it that, witho' +
          'ut'#13
        
          'permission, would make you directly or secondarily liable for   ' +
          #13
        
          'infringement under applicable copyright law, except executing it' +
          ' on a'#13
        
          'computer or modifying a private copy.  Propagation includes copy' +
          'ing,   '#13
        
          'distribution (with or without modification), making available to' +
          ' the'#13
        'public, and in some countries other activities as well.   '#13
        #13
        
          '  To "convey" a work means any kind of propagation that enables ' +
          'other   '#13
        
          'parties to make or receive copies.  Mere interaction with a user' +
          ' through'#13
        
          'a computer network, with no transfer of a copy, is not conveying' +
          '.   '#13
        #13
        
          '  An interactive user interface displays "Appropriate Legal Noti' +
          'ces"   '#13
        
          'to the extent that it includes a convenient and prominently visi' +
          'ble'#13
        
          'feature that (1) displays an appropriate copyright notice, and (' +
          '2)   '#13
        
          'tells the user that there is no warranty for the work (except to' +
          ' the'#13
        
          'extent that warranties are provided), that licensees may convey ' +
          'the   '#13
        
          'work under this License, and how to view a copy of this License.' +
          '  If'#13
        
          'the interface presents a list of user commands or options, such ' +
          'as a   '#13
        'menu, a prominent item in the list meets this criterion.'#13
        '   '#13
        '  1. Source Code.'#13
        '   '#13
        
          '  The "source code" for a work means the preferred form of the w' +
          'ork'#13
        
          'for making modifications to it.  "Object code" means any non-sou' +
          'rce   '#13
        'form of a work.'#13
        '   '#13
        
          '  A "Standard Interface" means an interface that either is an of' +
          'ficial'#13
        
          'standard defined by a recognized standards body, or, in the case' +
          ' of   '#13
        
          'interfaces specified for a particular programming language, one ' +
          'that'#13
        'is widely used among developers working in that language.   '#13
        #13
        
          '  The "System Libraries" of an executable work include anything,' +
          ' other   '#13
        
          'than the work as a whole, that (a) is included in the normal for' +
          'm of'#13
        
          'packaging a Major Component, but which is not part of that Major' +
          '   '#13
        
          'Component, and (b) serves only to enable use of the work with th' +
          'at'#13
        
          'Major Component, or to implement a Standard Interface for which ' +
          'an   '#13
        
          'implementation is available to the public in source code form.  ' +
          'A'#13
        
          '"Major Component", in this context, means a major essential comp' +
          'onent   '#13
        
          '(kernel, window system, and so on) of the specific operating sys' +
          'tem'#13
        
          '(if any) on which the executable work runs, or a compiler used t' +
          'o   '#13
        'produce the work, or an object code interpreter used to run it.'#13
        '   '#13
        
          '  The "Corresponding Source" for a work in object code form mean' +
          's all'#13
        
          'the source code needed to generate, install, and (for an executa' +
          'ble   '#13
        
          'work) run the object code and to modify the work, including scri' +
          'pts to'#13
        
          'control those activities.  However, it does not include the work' +
          #39's   '#13
        
          'System Libraries, or general-purpose tools or generally availabl' +
          'e free'#13
        
          'programs which are used unmodified in performing those activitie' +
          's but   '#13
        
          'which are not part of the work.  For example, Corresponding Sour' +
          'ce'#13
        
          'includes interface definition files associated with source files' +
          ' for   '#13
        
          'the work, and the source code for shared libraries and dynamical' +
          'ly'#13
        
          'linked subprograms that the work is specifically designed to req' +
          'uire,   '#13
        
          'such as by intimate data communication or control flow between t' +
          'hose'#13
        'subprograms and other parts of the work.   '#13
        #13
        
          '  The Corresponding Source need not include anything that users ' +
          '  '#13
        
          'can regenerate automatically from other parts of the Correspondi' +
          'ng'#13
        'Source.   '#13
        #13
        
          '  The Corresponding Source for a work in source code form is tha' +
          't   '#13
        'same work.'#13
        '   '#13
        '  2. Basic Permissions.'#13
        '   '#13
        
          '  All rights granted under this License are granted for the term' +
          ' of'#13
        
          'copyright on the Program, and are irrevocable provided the state' +
          'd   '#13
        
          'conditions are met.  This License explicitly affirms your unlimi' +
          'ted'#13
        
          'permission to run the unmodified Program.  The output from runni' +
          'ng a   '#13
        
          'covered work is covered by this License only if the output, give' +
          'n its'#13
        
          'content, constitutes a covered work.  This License acknowledges ' +
          'your   '#13
        
          'rights of fair use or other equivalent, as provided by copyright' +
          ' law.'#13
        '   '#13
        '  You may make, run and propagate covered works that you do not'#13
        
          'convey, without conditions so long as your license otherwise rem' +
          'ains   '#13
        
          'in force.  You may convey covered works to others for the sole p' +
          'urpose'#13
        
          'of having them make modifications exclusively for you, or provid' +
          'e you   '#13
        
          'with facilities for running those works, provided that you compl' +
          'y with'#13
        
          'the terms of this License in conveying all material for which yo' +
          'u do   '#13
        
          'not control copyright.  Those thus making or running the covered' +
          ' works'#13
        
          'for you must do so exclusively on your behalf, under your direct' +
          'ion   '#13
        
          'and control, on terms that prohibit them from making any copies ' +
          'of'#13
        
          'your copyrighted material outside their relationship with you.  ' +
          ' '#13
        #13
        
          '  Conveying under any other circumstances is permitted solely un' +
          'der   '#13
        
          'the conditions stated below.  Sublicensing is not allowed; secti' +
          'on 10'#13
        'makes it unnecessary.   '#13
        #13
        
          '  3. Protecting Users'#39' Legal Rights From Anti-Circumvention Law.' +
          '   '#13
        #13
        
          '  No covered work shall be deemed part of an effective technolog' +
          'ical   '#13
        
          'measure under any applicable law fulfilling obligations under ar' +
          'ticle'#13
        
          '11 of the WIPO copyright treaty adopted on 20 December 1996, or ' +
          '  '#13
        'similar laws prohibiting or restricting circumvention of such'#13
        'measures.   '#13
        #13
        
          '  When you convey a covered work, you waive any legal power to f' +
          'orbid   '#13
        
          'circumvention of technological measures to the extent such circu' +
          'mvention'#13
        
          'is effected by exercising rights under this License with respect' +
          ' to   '#13
        
          'the covered work, and you disclaim any intention to limit operat' +
          'ion or'#13
        
          'modification of the work as a means of enforcing, against the wo' +
          'rk'#39's   '#13
        
          'users, your or third parties'#39' legal rights to forbid circumventi' +
          'on of'#13
        'technological measures.   '#13
        #13
        '  4. Conveying Verbatim Copies.   '#13
        #13
        
          '  You may convey verbatim copies of the Program'#39's source code as' +
          ' you   '#13
        'receive it, in any medium, provided that you conspicuously and'#13
        
          'appropriately publish on each copy an appropriate copyright noti' +
          'ce;   '#13
        'keep intact all notices stating that this License and any'#13
        
          'non-permissive terms added in accord with section 7 apply to the' +
          ' code;   '#13
        
          'keep intact all notices of the absence of any warranty; and give' +
          ' all'#13
        'recipients a copy of this License along with the Program.   '#13
        #13
        
          '  You may charge any price or no price for each copy that you co' +
          'nvey,   '#13
        'and you may offer support or warranty protection for a fee.'#13
        '   '#13
        '  5. Conveying Modified Source Versions.'#13
        '   '#13
        
          '  You may convey a work based on the Program, or the modificatio' +
          'ns to'#13
        
          'produce it from the Program, in the form of source code under th' +
          'e   '#13
        
          'terms of section 4, provided that you also meet all of these con' +
          'ditions:'#13
        '   '#13
        
          '    a) The work must carry prominent notices stating that you mo' +
          'dified'#13
        '    it, and giving a relevant date.   '#13
        #13
        
          '    b) The work must carry prominent notices stating that it is ' +
          '  '#13
        
          '    released under this License and any conditions added under s' +
          'ection'#13
        
          '    7.  This requirement modifies the requirement in section 4 t' +
          'o   '#13
        '    "keep intact all notices".'#13
        '   '#13
        '    c) You must license the entire work, as a whole, under this'#13
        
          '    License to anyone who comes into possession of a copy.  This' +
          '   '#13
        
          '    License will therefore apply, along with any applicable sect' +
          'ion 7'#13
        
          '    additional terms, to the whole of the work, and all its part' +
          's,   '#13
        '    regardless of how they are packaged.  This License gives no'#13
        
          '    permission to license the work in any other way, but it does' +
          ' not   '#13
        
          '    invalidate such permission if you have separately received i' +
          't.'#13
        '   '#13
        
          '    d) If the work has interactive user interfaces, each must di' +
          'splay'#13
        
          '    Appropriate Legal Notices; however, if the Program has inter' +
          'active   '#13
        
          '    interfaces that do not display Appropriate Legal Notices, yo' +
          'ur'#13
        '    work need not make them do so.   '#13
        #13
        
          '  A compilation of a covered work with other separate and indepe' +
          'ndent   '#13
        
          'works, which are not by their nature extensions of the covered w' +
          'ork,'#13
        
          'and which are not combined with it such as to form a larger prog' +
          'ram,   '#13
        
          'in or on a volume of a storage or distribution medium, is called' +
          ' an'#13
        
          '"aggregate" if the compilation and its resulting copyright are n' +
          'ot   '#13
        
          'used to limit the access or legal rights of the compilation'#39's us' +
          'ers'#13
        
          'beyond what the individual works permit.  Inclusion of a covered' +
          ' work   '#13
        
          'in an aggregate does not cause this License to apply to the othe' +
          'r'#13
        'parts of the aggregate.   '#13
        #13
        '  6. Conveying Non-Source Forms.   '#13
        #13
        
          '  You may convey a covered work in object code form under the te' +
          'rms   '#13
        'of sections 4 and 5, provided that you also convey the'#13
        
          'machine-readable Corresponding Source under the terms of this Li' +
          'cense,   '#13
        'in one of these ways:'#13
        '   '#13
        
          '    a) Convey the object code in, or embodied in, a physical pro' +
          'duct'#13
        
          '    (including a physical distribution medium), accompanied by t' +
          'he   '#13
        '    Corresponding Source fixed on a durable physical medium'#13
        '    customarily used for software interchange.   '#13
        #13
        
          '    b) Convey the object code in, or embodied in, a physical pro' +
          'duct   '#13
        
          '    (including a physical distribution medium), accompanied by a' +
          #13
        
          '    written offer, valid for at least three years and valid for ' +
          'as   '#13
        
          '    long as you offer spare parts or customer support for that p' +
          'roduct'#13
        
          '    model, to give anyone who possesses the object code either (' +
          '1) a   '#13
        
          '    copy of the Corresponding Source for all the software in the' +
          #13
        
          '    product that is covered by this License, on a durable physic' +
          'al   '#13
        
          '    medium customarily used for software interchange, for a pric' +
          'e no'#13
        
          '    more than your reasonable cost of physically performing this' +
          '   '#13
        '    conveying of source, or (2) access to copy the'#13
        '    Corresponding Source from a network server at no charge.   '#13
        #13
        
          '    c) Convey individual copies of the object code with a copy o' +
          'f the   '#13
        '    written offer to provide the Corresponding Source.  This'#13
        
          '    alternative is allowed only occasionally and noncommercially' +
          ', and   '#13
        
          '    only if you received the object code with such an offer, in ' +
          'accord'#13
        '    with subsection 6b.   '#13
        #13
        
          '    d) Convey the object code by offering access from a designat' +
          'ed   '#13
        
          '    place (gratis or for a charge), and offer equivalent access ' +
          'to the'#13
        
          '    Corresponding Source in the same way through the same place ' +
          'at no   '#13
        
          '    further charge.  You need not require recipients to copy the' +
          #13
        
          '    Corresponding Source along with the object code.  If the pla' +
          'ce to   '#13
        
          '    copy the object code is a network server, the Corresponding ' +
          'Source'#13
        
          '    may be on a different server (operated by you or a third par' +
          'ty)   '#13
        
          '    that supports equivalent copying facilities, provided you ma' +
          'intain'#13
        
          '    clear directions next to the object code saying where to fin' +
          'd the   '#13
        '    Corresponding Source.  Regardless of what server hosts the'#13
        
          '    Corresponding Source, you remain obligated to ensure that it' +
          ' is   '#13
        
          '    available for as long as needed to satisfy these requirement' +
          's.'#13
        '   '#13
        
          '    e) Convey the object code using peer-to-peer transmission, p' +
          'rovided'#13
        
          '    you inform other peers where the object code and Correspondi' +
          'ng   '#13
        
          '    Source of the work are being offered to the general public a' +
          't no'#13
        '    charge under subsection 6d.   '#13
        #13
        
          '  A separable portion of the object code, whose source code is e' +
          'xcluded   '#13
        'from the Corresponding Source as a System Library, need not be'#13
        'included in conveying the object code work.   '#13
        #13
        
          '  A "User Product" is either (1) a "consumer product", which mea' +
          'ns any   '#13
        
          'tangible personal property which is normally used for personal, ' +
          'family,'#13
        
          'or household purposes, or (2) anything designed or sold for inco' +
          'rporation   '#13
        
          'into a dwelling.  In determining whether a product is a consumer' +
          ' product,'#13
        
          'doubtful cases shall be resolved in favor of coverage.  For a pa' +
          'rticular   '#13
        
          'product received by a particular user, "normally used" refers to' +
          ' a'#13
        
          'typical or common use of that class of product, regardless of th' +
          'e status   '#13
        
          'of the particular user or of the way in which the particular use' +
          'r'#13
        
          'actually uses, or expects or is expected to use, the product.  A' +
          ' product   '#13
        
          'is a consumer product regardless of whether the product has subs' +
          'tantial'#13
        
          'commercial, industrial or non-consumer uses, unless such uses re' +
          'present   '#13
        'the only significant mode of use of the product.'#13
        '   '#13
        
          '  "Installation Information" for a User Product means any method' +
          's,'#13
        
          'procedures, authorization keys, or other information required to' +
          ' install   '#13
        
          'and execute modified versions of a covered work in that User Pro' +
          'duct from'#13
        
          'a modified version of its Corresponding Source.  The information' +
          ' must   '#13
        
          'suffice to ensure that the continued functioning of the modified' +
          ' object'#13
        
          'code is in no case prevented or interfered with solely because  ' +
          ' '#13
        'modification has been made.'#13
        '   '#13
        
          '  If you convey an object code work under this section in, or wi' +
          'th, or'#13
        
          'specifically for use in, a User Product, and the conveying occur' +
          's as   '#13
        
          'part of a transaction in which the right of possession and use o' +
          'f the'#13
        
          'User Product is transferred to the recipient in perpetuity or fo' +
          'r a   '#13
        
          'fixed term (regardless of how the transaction is characterized),' +
          ' the'#13
        
          'Corresponding Source conveyed under this section must be accompa' +
          'nied   '#13
        
          'by the Installation Information.  But this requirement does not ' +
          'apply'#13
        
          'if neither you nor any third party retains the ability to instal' +
          'l   '#13
        
          'modified object code on the User Product (for example, the work ' +
          'has'#13
        'been installed in ROM).   '#13
        #13
        
          '  The requirement to provide Installation Information does not i' +
          'nclude a   '#13
        
          'requirement to continue to provide support service, warranty, or' +
          ' updates'#13
        
          'for a work that has been modified or installed by the recipient,' +
          ' or for   '#13
        
          'the User Product in which it has been modified or installed.  Ac' +
          'cess to a'#13
        
          'network may be denied when the modification itself materially an' +
          'd   '#13
        
          'adversely affects the operation of the network or violates the r' +
          'ules and'#13
        'protocols for communication across the network.   '#13
        #13
        
          '  Corresponding Source conveyed, and Installation Information pr' +
          'ovided,   '#13
        
          'in accord with this section must be in a format that is publicly' +
          #13
        
          'documented (and with an implementation available to the public i' +
          'n   '#13
        
          'source code form), and must require no special password or key f' +
          'or'#13
        'unpacking, reading or copying.   '#13
        #13
        '  7. Additional Terms.   '#13
        #13
        
          '  "Additional permissions" are terms that supplement the terms o' +
          'f this   '#13
        
          'License by making exceptions from one or more of its conditions.' +
          #13
        
          'Additional permissions that are applicable to the entire Program' +
          ' shall   '#13
        
          'be treated as though they were included in this License, to the ' +
          'extent'#13
        
          'that they are valid under applicable law.  If additional permiss' +
          'ions   '#13
        
          'apply only to part of the Program, that part may be used separat' +
          'ely'#13
        
          'under those permissions, but the entire Program remains governed' +
          ' by   '#13
        'this License without regard to the additional permissions.'#13
        '   '#13
        
          '  When you convey a copy of a covered work, you may at your opti' +
          'on'#13
        
          'remove any additional permissions from that copy, or from any pa' +
          'rt of   '#13
        
          'it.  (Additional permissions may be written to require their own' +
          #13
        
          'removal in certain cases when you modify the work.)  You may pla' +
          'ce   '#13
        
          'additional permissions on material, added by you to a covered wo' +
          'rk,'#13
        
          'for which you have or can give appropriate copyright permission.' +
          '   '#13
        #13
        
          '  Notwithstanding any other provision of this License, for mater' +
          'ial you   '#13
        
          'add to a covered work, you may (if authorized by the copyright h' +
          'olders of'#13
        
          'that material) supplement the terms of this License with terms: ' +
          '  '#13
        #13
        
          '    a) Disclaiming warranty or limiting liability differently fr' +
          'om the   '#13
        '    terms of sections 15 and 16 of this License; or'#13
        '   '#13
        
          '    b) Requiring preservation of specified reasonable legal noti' +
          'ces or'#13
        
          '    author attributions in that material or in the Appropriate L' +
          'egal   '#13
        '    Notices displayed by works containing it; or'#13
        '   '#13
        
          '    c) Prohibiting misrepresentation of the origin of that mater' +
          'ial, or'#13
        
          '    requiring that modified versions of such material be marked ' +
          'in   '#13
        '    reasonable ways as different from the original version; or'#13
        '   '#13
        
          '    d) Limiting the use for publicity purposes of names of licen' +
          'sors or'#13
        '    authors of the material; or   '#13
        #13
        
          '    e) Declining to grant rights under trademark law for use of ' +
          'some   '#13
        '    trade names, trademarks, or service marks; or'#13
        '   '#13
        
          '    f) Requiring indemnification of licensors and authors of tha' +
          't'#13
        
          '    material by anyone who conveys the material (or modified ver' +
          'sions of   '#13
        
          '    it) with contractual assumptions of liability to the recipie' +
          'nt, for'#13
        
          '    any liability that these contractual assumptions directly im' +
          'pose on   '#13
        '    those licensors and authors.'#13
        '   '#13
        
          '  All other non-permissive additional terms are considered "furt' +
          'her'#13
        
          'restrictions" within the meaning of section 10.  If the Program ' +
          'as you   '#13
        
          'received it, or any part of it, contains a notice stating that i' +
          't is'#13
        'governed by this License along with a term that is a further   '#13
        
          'restriction, you may remove that term.  If a license document co' +
          'ntains'#13
        
          'a further restriction but permits relicensing or conveying under' +
          ' this   '#13
        
          'License, you may add to a covered work material governed by the ' +
          'terms'#13
        
          'of that license document, provided that the further restriction ' +
          'does   '#13
        'not survive such relicensing or conveying.'#13
        '   '#13
        
          '  If you add terms to a covered work in accord with this section' +
          ', you'#13
        'must place, in the relevant source files, a statement of the   '#13
        
          'additional terms that apply to those files, or a notice indicati' +
          'ng'#13
        'where to find the applicable terms.   '#13
        #13
        
          '  Additional terms, permissive or non-permissive, may be stated ' +
          'in the   '#13
        'form of a separately written license, or stated as exceptions;'#13
        'the above requirements apply either way.   '#13
        #13
        '  8. Termination.   '#13
        #13
        
          '  You may not propagate or modify a covered work except as expre' +
          'ssly   '#13
        
          'provided under this License.  Any attempt otherwise to propagate' +
          ' or'#13
        
          'modify it is void, and will automatically terminate your rights ' +
          'under   '#13
        
          'this License (including any patent licenses granted under the th' +
          'ird'#13
        'paragraph of section 11).   '#13
        #13
        
          '  However, if you cease all violation of this License, then your' +
          '   '#13
        'license from a particular copyright holder is reinstated (a)'#13
        
          'provisionally, unless and until the copyright holder explicitly ' +
          'and   '#13
        
          'finally terminates your license, and (b) permanently, if the cop' +
          'yright'#13
        
          'holder fails to notify you of the violation by some reasonable m' +
          'eans   '#13
        'prior to 60 days after the cessation.'#13
        '   '#13
        '  Moreover, your license from a particular copyright holder is'#13
        
          'reinstated permanently if the copyright holder notifies you of t' +
          'he   '#13
        
          'violation by some reasonable means, this is the first time you h' +
          'ave'#13
        
          'received notice of violation of this License (for any work) from' +
          ' that   '#13
        
          'copyright holder, and you cure the violation prior to 30 days af' +
          'ter'#13
        'your receipt of the notice.   '#13
        #13
        
          '  Termination of your rights under this section does not termina' +
          'te the   '#13
        
          'licenses of parties who have received copies or rights from you ' +
          'under'#13
        
          'this License.  If your rights have been terminated and not perma' +
          'nently   '#13
        
          'reinstated, you do not qualify to receive new licenses for the s' +
          'ame'#13
        'material under section 10.   '#13
        #13
        '  9. Acceptance Not Required for Having Copies.   '#13
        #13
        
          '  You are not required to accept this License in order to receiv' +
          'e or   '#13
        
          'run a copy of the Program.  Ancillary propagation of a covered w' +
          'ork'#13
        
          'occurring solely as a consequence of using peer-to-peer transmis' +
          'sion   '#13
        
          'to receive a copy likewise does not require acceptance.  However' +
          ','#13
        
          'nothing other than this License grants you permission to propaga' +
          'te or   '#13
        
          'modify any covered work.  These actions infringe copyright if yo' +
          'u do'#13
        
          'not accept this License.  Therefore, by modifying or propagating' +
          ' a   '#13
        
          'covered work, you indicate your acceptance of this License to do' +
          ' so.'#13
        '   '#13
        '  10. Automatic Licensing of Downstream Recipients.'#13
        '   '#13
        
          '  Each time you convey a covered work, the recipient automatical' +
          'ly'#13
        
          'receives a license from the original licensors, to run, modify a' +
          'nd   '#13
        
          'propagate that work, subject to this License.  You are not respo' +
          'nsible'#13
        'for enforcing compliance by third parties with this License.   '#13
        #13
        
          '  An "entity transaction" is a transaction transferring control ' +
          'of an   '#13
        
          'organization, or substantially all assets of one, or subdividing' +
          ' an'#13
        
          'organization, or merging organizations.  If propagation of a cov' +
          'ered   '#13
        'work results from an entity transaction, each party to that'#13
        
          'transaction who receives a copy of the work also receives whatev' +
          'er   '#13
        
          'licenses to the work the party'#39's predecessor in interest had or ' +
          'could'#13
        
          'give under the previous paragraph, plus a right to possession of' +
          ' the   '#13
        
          'Corresponding Source of the work from the predecessor in interes' +
          't, if'#13
        
          'the predecessor has it or can get it with reasonable efforts.   ' +
          #13
        #13
        
          '  You may not impose any further restrictions on the exercise of' +
          ' the   '#13
        
          'rights granted or affirmed under this License.  For example, you' +
          ' may'#13
        
          'not impose a license fee, royalty, or other charge for exercise ' +
          'of   '#13
        
          'rights granted under this License, and you may not initiate liti' +
          'gation'#13
        
          '(including a cross-claim or counterclaim in a lawsuit) alleging ' +
          'that   '#13
        
          'any patent claim is infringed by making, using, selling, offerin' +
          'g for'#13
        'sale, or importing the Program or any portion of it.   '#13
        #13
        '  11. Patents.   '#13
        #13
        
          '  A "contributor" is a copyright holder who authorizes use under' +
          ' this   '#13
        
          'License of the Program or a work on which the Program is based. ' +
          ' The'#13
        
          'work thus licensed is called the contributor'#39's "contributor vers' +
          'ion".   '#13
        #13
        
          '  A contributor'#39's "essential patent claims" are all patent claim' +
          's   '#13
        
          'owned or controlled by the contributor, whether already acquired' +
          ' or'#13
        
          'hereafter acquired, that would be infringed by some manner, perm' +
          'itted   '#13
        
          'by this License, of making, using, or selling its contributor ve' +
          'rsion,'#13
        'but do not include claims that would be infringed only as a   '#13
        
          'consequence of further modification of the contributor version. ' +
          ' For'#13
        
          'purposes of this definition, "control" includes the right to gra' +
          'nt   '#13
        
          'patent sublicenses in a manner consistent with the requirements ' +
          'of'#13
        'this License.   '#13
        #13
        
          '  Each contributor grants you a non-exclusive, worldwide, royalt' +
          'y-free   '#13
        
          'patent license under the contributor'#39's essential patent claims, ' +
          'to'#13
        
          'make, use, sell, offer for sale, import and otherwise run, modif' +
          'y and   '#13
        'propagate the contents of its contributor version.'#13
        '   '#13
        
          '  In the following three paragraphs, a "patent license" is any e' +
          'xpress'#13
        
          'agreement or commitment, however denominated, not to enforce a p' +
          'atent   '#13
        
          '(such as an express permission to practice a patent or covenant ' +
          'not to'#13
        
          'sue for patent infringement).  To "grant" such a patent license ' +
          'to a   '#13
        
          'party means to make such an agreement or commitment not to enfor' +
          'ce a'#13
        'patent against the party.   '#13
        #13
        
          '  If you convey a covered work, knowingly relying on a patent li' +
          'cense,   '#13
        
          'and the Corresponding Source of the work is not available for an' +
          'yone'#13
        
          'to copy, free of charge and under the terms of this License, thr' +
          'ough a   '#13
        
          'publicly available network server or other readily accessible me' +
          'ans,'#13
        
          'then you must either (1) cause the Corresponding Source to be so' +
          '   '#13
        
          'available, or (2) arrange to deprive yourself of the benefit of ' +
          'the'#13
        
          'patent license for this particular work, or (3) arrange, in a ma' +
          'nner   '#13
        
          'consistent with the requirements of this License, to extend the ' +
          'patent'#13
        
          'license to downstream recipients.  "Knowingly relying" means you' +
          ' have   '#13
        
          'actual knowledge that, but for the patent license, your conveyin' +
          'g the'#13
        
          'covered work in a country, or your recipient'#39's use of the covere' +
          'd work   '#13
        
          'in a country, would infringe one or more identifiable patents in' +
          ' that'#13
        'country that you have reason to believe are valid.   '#13
        #13
        
          '  If, pursuant to or in connection with a single transaction or ' +
          '  '#13
        
          'arrangement, you convey, or propagate by procuring conveyance of' +
          ', a'#13
        
          'covered work, and grant a patent license to some of the parties ' +
          '  '#13
        
          'receiving the covered work authorizing them to use, propagate, m' +
          'odify'#13
        
          'or convey a specific copy of the covered work, then the patent l' +
          'icense   '#13
        
          'you grant is automatically extended to all recipients of the cov' +
          'ered'#13
        'work and works based on it.   '#13
        #13
        
          '  A patent license is "discriminatory" if it does not include wi' +
          'thin   '#13
        'the scope of its coverage, prohibits the exercise of, or is'#13
        
          'conditioned on the non-exercise of one or more of the rights tha' +
          't are   '#13
        
          'specifically granted under this License.  You may not convey a c' +
          'overed'#13
        
          'work if you are a party to an arrangement with a third party tha' +
          't is   '#13
        
          'in the business of distributing software, under which you make p' +
          'ayment'#13
        
          'to the third party based on the extent of your activity of conve' +
          'ying   '#13
        'the work, and under which the third party grants, to any of the'#13
        
          'parties who would receive the covered work from you, a discrimin' +
          'atory   '#13
        
          'patent license (a) in connection with copies of the covered work' +
          #13
        
          'conveyed by you (or copies made from those copies), or (b) prima' +
          'rily   '#13
        
          'for and in connection with specific products or compilations tha' +
          't'#13
        
          'contain the covered work, unless you entered into that arrangeme' +
          'nt,   '#13
        'or that patent license was granted, prior to 28 March 2007.'#13
        '   '#13
        
          '  Nothing in this License shall be construed as excluding or lim' +
          'iting'#13
        
          'any implied license or other defenses to infringement that may  ' +
          ' '#13
        'otherwise be available to you under applicable patent law.'#13
        '   '#13
        '  12. No Surrender of Others'#39' Freedom.'#13
        '   '#13
        
          '  If conditions are imposed on you (whether by court order, agre' +
          'ement or'#13
        
          'otherwise) that contradict the conditions of this License, they ' +
          'do not   '#13
        
          'excuse you from the conditions of this License.  If you cannot c' +
          'onvey a'#13
        
          'covered work so as to satisfy simultaneously your obligations un' +
          'der this   '#13
        
          'License and any other pertinent obligations, then as a consequen' +
          'ce you may'#13
        
          'not convey it at all.  For example, if you agree to terms that o' +
          'bligate you   '#13
        
          'to collect a royalty for further conveying from those to whom yo' +
          'u convey'#13
        
          'the Program, the only way you could satisfy both those terms and' +
          ' this   '#13
        
          'License would be to refrain entirely from conveying the Program.' +
          #13
        '   '#13
        '  13. Use with the GNU Affero General Public License.'#13
        '   '#13
        '  Notwithstanding any other provision of this License, you have'#13
        
          'permission to link or combine any covered work with a work licen' +
          'sed   '#13
        
          'under version 3 of the GNU Affero General Public License into a ' +
          'single'#13
        
          'combined work, and to convey the resulting work.  The terms of t' +
          'his   '#13
        
          'License will continue to apply to the part which is the covered ' +
          'work,'#13
        
          'but the special requirements of the GNU Affero General Public Li' +
          'cense,   '#13
        
          'section 13, concerning interaction through a network will apply ' +
          'to the'#13
        'combination as such.   '#13
        #13
        '  14. Revised Versions of this License.   '#13
        #13
        
          '  The Free Software Foundation may publish revised and/or new ve' +
          'rsions of   '#13
        
          'the GNU General Public License from time to time.  Such new vers' +
          'ions will'#13
        
          'be similar in spirit to the present version, but may differ in d' +
          'etail to   '#13
        'address new problems or concerns.'#13
        '   '#13
        
          '  Each version is given a distinguishing version number.  If the' +
          #13
        
          'Program specifies that a certain numbered version of the GNU Gen' +
          'eral   '#13
        
          'Public License "or any later version" applies to it, you have th' +
          'e'#13
        
          'option of following the terms and conditions either of that numb' +
          'ered   '#13
        'version or of any later version published by the Free Software'#13
        
          'Foundation.  If the Program does not specify a version number of' +
          ' the   '#13
        
          'GNU General Public License, you may choose any version ever publ' +
          'ished'#13
        'by the Free Software Foundation.   '#13
        #13
        
          '  If the Program specifies that a proxy can decide which future ' +
          '  '#13
        
          'versions of the GNU General Public License can be used, that pro' +
          'xy'#39's'#13
        
          'public statement of acceptance of a version permanently authoriz' +
          'es you   '#13
        'to choose that version for the Program.'#13
        '   '#13
        '  Later license versions may give you additional or different'#13
        
          'permissions.  However, no additional obligations are imposed on ' +
          'any   '#13
        
          'author or copyright holder as a result of your choosing to follo' +
          'w a'#13
        'later version.   '#13
        #13
        '  15. Disclaimer of Warranty.   '#13
        #13
        
          '  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED ' +
          'BY   '#13
        'APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE '#13
        'COPYRIGHT  '#13
        
          'HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT' +
          ' '#13
        'WARRANTY   '#13
        
          'OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIM' +
          'ITED '#13
        'TO,  '#13
        'THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A '#13
        'PARTICULAR   '#13
        
          'PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF T' +
          'HE '#13
        'PROGRAM  '#13
        
          'IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE' +
          ' '#13
        'COST OF   '#13
        'ALL NECESSARY SERVICING, REPAIR OR CORRECTION.'#13
        '   '#13
        '  16. Limitation of Liability.'#13
        '   '#13
        
          '  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN ' +
          #13
        'WRITING  '#13
        
          'WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/O' +
          'R '#13
        'CONVEYS   '#13
        'THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, '#13
        'INCLUDING ANY  '#13
        
          'GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OU' +
          'T '#13
        'OF THE   '#13
        
          'USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED T' +
          'O '#13
        'LOSS OF  '#13
        
          'DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YO' +
          'U '#13
        'OR THIRD   '#13
        'PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER '#13
        'PROGRAMS),  '#13
        'EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE '#13
        'POSSIBILITY OF   '#13
        'SUCH DAMAGES.'#13
        '   '#13
        '  17. Interpretation of Sections 15 and 16.'#13
        '   '#13
        
          '  If the disclaimer of warranty and limitation of liability prov' +
          'ided'#13
        
          'above cannot be given local legal effect according to their term' +
          's,   '#13
        
          'reviewing courts shall apply local law that most closely approxi' +
          'mates'#13
        
          'an absolute waiver of all civil liability in connection with the' +
          '   '#13
        
          'Program, unless a warranty or assumption of liability accompanie' +
          's a'#13
        'copy of the Program in return for a fee.   '#13
        #13
        '                     END OF TERMS AND CONDITIONS   '#13
        #13
        '            How to Apply These Terms to Your New Programs   '#13
        #13
        
          '  If you develop a new program, and you want it to be of the gre' +
          'atest   '#13
        
          'possible use to the public, the best way to achieve this is to m' +
          'ake it'#13
        
          'free software which everyone can redistribute and change under t' +
          'hese terms.   '#13
        #13
        
          '  To do so, attach the following notices to the program.  It is ' +
          'safest   '#13
        
          'to attach them to the start of each source file to most effectiv' +
          'ely'#13
        
          'state the exclusion of warranty; and each file should have at le' +
          'ast   '#13
        
          'the "copyright" line and a pointer to where the full notice is f' +
          'ound.'#13
        '   '#13
        
          '    <one line to give the program'#39's name and a brief idea of wha' +
          't it does.>'#13
        '    Copyright (C) <year>  <name of author>   '#13
        #13
        
          '    This program is free software: you can redistribute it and/o' +
          'r modify   '#13
        
          '    it under the terms of the GNU General Public License as publ' +
          'ished by'#13
        
          '    the Free Software Foundation, either version 3 of the Licens' +
          'e, or   '#13
        '    (at your option) any later version.'#13
        '   '#13
        
          '    This program is distributed in the hope that it will be usef' +
          'ul,'#13
        
          '    but WITHOUT ANY WARRANTY; without even the implied warranty ' +
          'of   '#13
        
          '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See th' +
          'e'#13
        '    GNU General Public License for more details.   '#13
        #13
        
          '    You should have received a copy of the GNU General Public Li' +
          'cense   '#13
        
          '    along with this program.  If not, see <http://www.gnu.org/li' +
          'censes/>.'#13
        '   '#13
        
          'Also add information on how to contact you by electronic and pap' +
          'er mail.'#13
        '   '#13
        
          '  If the program does terminal interaction, make it output a sho' +
          'rt'#13
        'notice like this when it starts in an interactive mode:   '#13
        #13
        '    <program>  Copyright (C) <year>  <name of author>   '#13
        
          '    This program comes with ABSOLUTELY NO WARRANTY; for details ' +
          'type `show w'#39'.'#13
        
          '    This is free software, and you are welcome to redistribute i' +
          't   '#13
        '    under certain conditions; type `show c'#39' for details.'#13
        '   '#13
        
          'The hypothetical commands `show w'#39' and `show c'#39' should show the ' +
          'appropriate'#13
        
          'parts of the General Public License.  Of course, your program'#39's ' +
          'commands   '#13
        
          'might be different; for a GUI interface, you would use an "about' +
          ' box".'#13
        '   '#13
        
          '  You should also get your employer (if you work as a programmer' +
          ') or school,'#13
        
          'if any, to sign a "copyright disclaimer" for the program, if nec' +
          'essary.   '#13
        
          'For more information on this, and how to apply and follow the GN' +
          'U GPL, see'#13
        '<http://www.gnu.org/licenses/>.   '#13
        #13
        
          '  The GNU General Public License does not permit incorporating y' +
          'our program   '#13
        
          'into proprietary programs.  If your program is a subroutine libr' +
          'ary, you'#13
        
          'may consider it more useful to permit linking proprietary applic' +
          'ations with   '#13
        
          'the library.  If this is what you want to do, use the GNU Lesser' +
          ' General'#13
        
          'Public License instead of this License.  But first, please read ' +
          '  '#13
        '<http://www.gnu.org/philosophy/why-not-lgpl.html>.'#13)
      ReadOnly = True
      TabOrder = 0
    end
  end
end
